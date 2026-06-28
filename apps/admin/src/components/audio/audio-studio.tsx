"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import WaveSurfer from "wavesurfer.js";
import { Mic, Square, Upload, Volume2, CheckCircle2, User } from "lucide-react";
import { audioUploadMetaSchema } from "@kuttiomp/validation";
import { ErrorAlert, MetadataField, SacredLanguageNotice } from "@kuttiomp/ui";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { api, ApiError } from "@/lib/api";
import type { Speaker } from "@kuttiomp/types";

interface AudioStudioProps {
  speakers: Speaker[];
  lexicalEntryId?: string;
}

const CONTEXT_TAGS = [
  "formal_lesson", "kitchen_conversation", "outdoor_teaching",
  "practice_session", "storytelling", "ceremony_prep", "elders_council",
];

const STEPS = ["Attribution", "Record", "Review & Upload"];

export function AudioStudio({ speakers, lexicalEntryId }: AudioStudioProps) {
  const [step, setStep] = useState(0);
  const [isRecording, setIsRecording] = useState(false);
  const [hasRecording, setHasRecording] = useState(false);
  const [uploaded, setUploaded] = useState(false);
  const [selectedSpeaker, setSelectedSpeaker] = useState("");
  const [recordedBy, setRecordedBy] = useState("");
  const [recordingContext, setRecordingContext] = useState("");
  const [selectedTags, setSelectedTags] = useState<string[]>([]);
  const [quality, setQuality] = useState("field");
  const [status, setStatus] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [duration, setDuration] = useState(0);
  const [uploading, setUploading] = useState(false);

  const waveformRef = useRef<HTMLDivElement>(null);
  const wavesurferRef = useRef<WaveSurfer | null>(null);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const chunksRef = useRef<Blob[]>([]);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => () => {
    wavesurferRef.current?.destroy();
    if (timerRef.current) clearInterval(timerRef.current);
  }, []);

  const initWaveform = useCallback(async (blob: Blob) => {
    if (!waveformRef.current) return;
    wavesurferRef.current?.destroy();
    const ws = WaveSurfer.create({
      container: waveformRef.current,
      waveColor: "#6B7F5E",
      progressColor: "#2D5A3D",
      cursorColor: "#3D2914",
      height: 88,
      barWidth: 2,
      barGap: 1,
      normalize: true,
    });
    wavesurferRef.current = ws;
    await ws.loadBlob(blob);
  }, []);

  const startRecording = useCallback(async () => {
    if (!selectedSpeaker) {
      setError("Select the speaker whose voice will be recorded (Protocol 1).");
      return;
    }
    setError(null);
    setUploaded(false);
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const mimeType = MediaRecorder.isTypeSupported("audio/webm;codecs=opus")
        ? "audio/webm;codecs=opus" : "audio/webm";
      const recorder = new MediaRecorder(stream, { mimeType });
      mediaRecorderRef.current = recorder;
      chunksRef.current = [];
      setDuration(0);
      setHasRecording(false);

      recorder.ondataavailable = (e) => {
        if (e.data.size > 0) chunksRef.current.push(e.data);
      };

      recorder.onstop = async () => {
        const blob = new Blob(chunksRef.current, { type: "audio/webm" });
        await initWaveform(blob);
        setHasRecording(true);
        setStep(2);
        stream.getTracks().forEach((t) => t.stop());
        if (timerRef.current) clearInterval(timerRef.current);
      };

      recorder.start(250);
      setIsRecording(true);
      setStep(1);
      setStatus("Recording — speak clearly. The language deserves your full voice.");
      timerRef.current = setInterval(() => setDuration((d) => d + 1), 1000);
    } catch {
      setError("Microphone access is required to honor and record living language.");
    }
  }, [selectedSpeaker, initWaveform]);

  const stopRecording = useCallback(() => {
    mediaRecorderRef.current?.stop();
    setIsRecording(false);
    setStatus("Review the waveform. Upload when ready — recordings await elder approval.");
  }, []);

  const reset = useCallback(() => {
    chunksRef.current = [];
    setHasRecording(false);
    setUploaded(false);
    setDuration(0);
    setStep(0);
    setStatus("");
    wavesurferRef.current?.destroy();
  }, []);

  const upload = useCallback(async () => {
    setError(null);
    const meta = audioUploadMetaSchema.safeParse({
      speaker_id: selectedSpeaker,
      recorded_by: recordedBy || undefined,
      lexical_entry_id: lexicalEntryId,
      recording_context: recordingContext || undefined,
      quality,
      visibility: "clan",
      context_tags: selectedTags,
    });
    if (!meta.success) {
      setError(meta.error.issues[0]?.message ?? "Invalid recording metadata");
      return;
    }
    if (!hasRecording) {
      setError("Record audio before uploading.");
      return;
    }

    setUploading(true);
    setStatus("Uploading with speaker attribution...");
    const blob = new Blob(chunksRef.current, { type: "audio/webm" });
    const formData = new FormData();
    formData.append("file", blob, "recording.webm");
    formData.append("speaker_id", selectedSpeaker);
    formData.append("quality", quality);
    formData.append("visibility", "clan");
    if (lexicalEntryId) formData.append("lexical_entry_id", lexicalEntryId);
    if (recordingContext) formData.append("recording_context", recordingContext);
    if (recordedBy) formData.append("recorded_by", recordedBy);
    selectedTags.forEach((tag) => formData.append("context_tags", tag));

    try {
      await api.audio.upload(formData);
      setUploaded(true);
      setStatus("");
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Upload failed. Verify API and storage bucket.");
    } finally {
      setUploading(false);
    }
  }, [selectedSpeaker, recordedBy, lexicalEntryId, recordingContext, selectedTags, quality, hasRecording]);

  const formatTime = (s: number) =>
    `${Math.floor(s / 60)}:${(s % 60).toString().padStart(2, "0")}`;

  return (
    <div className="space-y-8">
      <SacredLanguageNotice compact />

      <div className="flex gap-2">
        {STEPS.map((label, i) => (
          <div
            key={label}
            className={`flex-1 rounded-md px-3 py-2 text-center text-xs font-medium transition-colors ${
              i === step ? "bg-emerald-900/10 text-emerald-900" : i < step ? "bg-stone-100 text-stone-600" : "bg-stone-50 text-stone-400"
            }`}
          >
            {i + 1}. {label}
          </div>
        ))}
      </div>

      {error && <ErrorAlert message={error} onRetry={() => setError(null)} />}

      {uploaded && (
        <div className="flex items-center gap-2 rounded-lg border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-900">
          <CheckCircle2 className="h-4 w-4" />
          Recording uploaded. Awaiting elder approval (Protocols 1 & 4).
          <Button variant="link" size="sm" className="ml-auto text-emerald-800" onClick={reset}>
            Record another
          </Button>
        </div>
      )}

      {!uploaded && (
        <div className="grid gap-6 lg:grid-cols-2">
          <div className="space-y-4">
            <MetadataField label="Speaker Attribution" required description="Protocol 1 — whose voice is recorded?">
              <Select value={selectedSpeaker} onValueChange={(v) => { setSelectedSpeaker(v); setStep(0); }}>
                <SelectTrigger><SelectValue placeholder="Select Knowledge Keeper" /></SelectTrigger>
                <SelectContent>
                  {speakers.length === 0 ? (
                    <SelectItem value="_none" disabled>No speakers — apply migrations</SelectItem>
                  ) : speakers.map((s) => (
                    <SelectItem key={s.id} value={s.id}>
                      {s.display_name} — {s.role}{s.is_elder ? " (Elder)" : ""}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </MetadataField>

            <MetadataField label="Recorded By" description="If someone else operated the device">
              <Select value={recordedBy || "_self"} onValueChange={(v) => setRecordedBy(v === "_self" ? "" : v)}>
                <SelectTrigger><SelectValue placeholder="Same as speaker (default)" /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="_self">Same as speaker</SelectItem>
                  {speakers.map((s) => (
                    <SelectItem key={s.id} value={s.id}>
                      <span className="flex items-center gap-1"><User className="h-3 w-3" />{s.display_name}</span>
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </MetadataField>

            <MetadataField label="Recording Quality">
              <Select value={quality} onValueChange={setQuality}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {["studio", "field", "archival", "practice", "live_ceremony"].map((q) => (
                    <SelectItem key={q} value={q}>{q.replace(/_/g, " ")}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </MetadataField>

            <MetadataField label="Recording Context">
              <input
                className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                placeholder="e.g., Kitchen conversation with Grandmother Comus"
                value={recordingContext}
                onChange={(e) => setRecordingContext(e.target.value)}
              />
            </MetadataField>

            <div className="space-y-2">
              <Label>Context Tags</Label>
              <div className="flex flex-wrap gap-2">
                {CONTEXT_TAGS.map((tag) => (
                  <Badge
                    key={tag}
                    variant={selectedTags.includes(tag) ? "default" : "outline"}
                    className="cursor-pointer"
                    onClick={() => setSelectedTags((prev) =>
                      prev.includes(tag) ? prev.filter((t) => t !== tag) : [...prev, tag]
                    )}
                  >
                    {tag.replace(/_/g, " ")}
                  </Badge>
                ))}
              </div>
            </div>
          </div>

          <div className="space-y-4">
            <div className="flex items-center gap-3 flex-wrap">
              {!isRecording ? (
                <Button onClick={startRecording} size="lg" className="gap-2" disabled={!selectedSpeaker}>
                  <Mic className="h-5 w-5" /> Record
                </Button>
              ) : (
                <Button onClick={stopRecording} variant="destructive" size="lg" className="gap-2">
                  <Square className="h-5 w-5" /> Stop
                </Button>
              )}
              {hasRecording && !isRecording && (
                <Button onClick={upload} variant="secondary" className="gap-2" disabled={uploading}>
                  <Upload className="h-4 w-4" /> {uploading ? "Uploading..." : "Upload"}
                </Button>
              )}
              {(isRecording || duration > 0) && (
                <span className="text-sm font-mono text-stone-500">{formatTime(duration)}</span>
              )}
            </div>

            <div className="rounded-lg border border-stone-200 bg-white p-4 min-h-[140px] shadow-sm">
              <div className="flex items-center gap-2 mb-3 text-stone-500">
                <Volume2 className="h-4 w-4" />
                <span className="text-xs uppercase tracking-wider">Waveform Preview</span>
              </div>
              <div ref={waveformRef} />
              {!hasRecording && !isRecording && (
                <p className="text-sm text-stone-400 text-center py-8">
                  Select a speaker, then record to see the waveform
                </p>
              )}
            </div>
          </div>
        </div>
      )}

      {status && !uploaded && <p className="text-sm text-stone-600 border-t border-stone-100 pt-4 italic">{status}</p>}
    </div>
  );
}