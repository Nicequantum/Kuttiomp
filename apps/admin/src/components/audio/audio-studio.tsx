"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import WaveSurfer from "wavesurfer.js";
import { Mic, Square, Upload, Volume2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { MetadataField } from "@kuttiomp/ui";
import { api } from "@/lib/api";
import type { Speaker } from "@kuttiomp/types";

interface AudioStudioProps {
  speakers: Speaker[];
  lexicalEntryId?: string;
}

const CONTEXT_TAGS = [
  "formal_lesson", "kitchen_conversation", "outdoor_teaching",
  "practice_session", "storytelling", "ceremony_prep", "elders_council",
];

export function AudioStudio({ speakers, lexicalEntryId }: AudioStudioProps) {
  const [isRecording, setIsRecording] = useState(false);
  const [selectedSpeaker, setSelectedSpeaker] = useState("");
  const [recordingContext, setRecordingContext] = useState("");
  const [selectedTags, setSelectedTags] = useState<string[]>([]);
  const [quality, setQuality] = useState("field");
  const [status, setStatus] = useState("");
  const [duration, setDuration] = useState(0);

  const waveformRef = useRef<HTMLDivElement>(null);
  const wavesurferRef = useRef<WaveSurfer | null>(null);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const chunksRef = useRef<Blob[]>([]);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    return () => {
      wavesurferRef.current?.destroy();
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, []);

  const initWaveform = useCallback(async (blob: Blob) => {
    if (!waveformRef.current) return;
    wavesurferRef.current?.destroy();
    const ws = WaveSurfer.create({
      container: waveformRef.current,
      waveColor: "#6B7F5E",
      progressColor: "#2D5A3D",
      cursorColor: "#3D2914",
      height: 80,
      barWidth: 2,
      barGap: 1,
      normalize: true,
    });
    wavesurferRef.current = ws;
    await ws.loadBlob(blob);
  }, []);

  const startRecording = useCallback(async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const recorder = new MediaRecorder(stream, { mimeType: "audio/webm" });
      mediaRecorderRef.current = recorder;
      chunksRef.current = [];
      setDuration(0);

      recorder.ondataavailable = (e) => {
        if (e.data.size > 0) chunksRef.current.push(e.data);
      };

      recorder.onstop = async () => {
        const blob = new Blob(chunksRef.current, { type: "audio/webm" });
        await initWaveform(blob);
        stream.getTracks().forEach((t) => t.stop());
        if (timerRef.current) clearInterval(timerRef.current);
      };

      recorder.start(100);
      setIsRecording(true);
      setStatus("Recording in progress...");
      timerRef.current = setInterval(() => setDuration((d) => d + 1), 1000);
    } catch {
      setStatus("Microphone access required. Please grant permission.");
    }
  }, [initWaveform]);

  const stopRecording = useCallback(() => {
    mediaRecorderRef.current?.stop();
    setIsRecording(false);
    setStatus("Recording complete. Review waveform and upload.");
  }, []);

  const upload = useCallback(async () => {
    if (!selectedSpeaker || chunksRef.current.length === 0) {
      setStatus("Select a speaker and record audio first.");
      return;
    }
    setStatus("Uploading with speaker attribution...");
    const blob = new Blob(chunksRef.current, { type: "audio/webm" });
    const formData = new FormData();
    formData.append("file", blob, "recording.webm");
    formData.append("speaker_id", selectedSpeaker);
    formData.append("quality", quality);
    formData.append("visibility", "clan");
    if (lexicalEntryId) formData.append("lexical_entry_id", lexicalEntryId);
    if (recordingContext) formData.append("recording_context", recordingContext);
    selectedTags.forEach((tag) => formData.append("context_tags", tag));

    try {
      await api.audio.upload(formData);
      setStatus("Uploaded. Awaiting elder approval (Protocol 1 & 4).");
    } catch {
      setStatus("Upload failed. Check API and Supabase storage bucket.");
    }
  }, [selectedSpeaker, lexicalEntryId, recordingContext, selectedTags, quality]);

  const formatTime = (s: number) =>
    `${Math.floor(s / 60)}:${(s % 60).toString().padStart(2, "0")}`;

  return (
    <div className="space-y-8">
      <div className="rounded-lg border border-emerald-900/10 bg-emerald-50/30 p-4">
        <p className="text-xs uppercase tracking-widest text-emerald-800/60 font-medium mb-1">
          Protocol 1: Speaker Sovereignty
        </p>
        <p className="text-sm text-stone-600">
          Every recording must be attributed to the speaker whose voice is captured.
        </p>
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        <div className="space-y-4">
          <MetadataField label="Speaker Attribution" required description="Whose voice is being recorded?">
            <Select value={selectedSpeaker} onValueChange={setSelectedSpeaker}>
              <SelectTrigger>
                <SelectValue placeholder="Select Knowledge Keeper" />
              </SelectTrigger>
              <SelectContent>
                {speakers.map((s) => (
                  <SelectItem key={s.id} value={s.id}>
                    {s.display_name} — {s.role}
                    {s.is_elder ? " (Elder)" : ""}
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
                  onClick={() =>
                    setSelectedTags((prev) =>
                      prev.includes(tag) ? prev.filter((t) => t !== tag) : [...prev, tag]
                    )
                  }
                >
                  {tag.replace(/_/g, " ")}
                </Badge>
              ))}
            </div>
          </div>
        </div>

        <div className="space-y-4">
          <div className="flex items-center gap-3">
            {!isRecording ? (
              <Button onClick={startRecording} size="lg" className="gap-2">
                <Mic className="h-5 w-5" /> Record
              </Button>
            ) : (
              <Button onClick={stopRecording} variant="destructive" size="lg" className="gap-2">
                <Square className="h-5 w-5" /> Stop
              </Button>
            )}
            {chunksRef.current.length > 0 && !isRecording && (
              <Button onClick={upload} variant="secondary" className="gap-2">
                <Upload className="h-4 w-4" /> Upload
              </Button>
            )}
            {(isRecording || duration > 0) && (
              <span className="text-sm font-mono text-stone-500">{formatTime(duration)}</span>
            )}
          </div>

          <div className="rounded-lg border bg-white p-4 min-h-[120px]">
            <div className="flex items-center gap-2 mb-3 text-stone-500">
              <Volume2 className="h-4 w-4" />
              <span className="text-xs uppercase tracking-wider">Waveform</span>
            </div>
            <div ref={waveformRef} />
            {chunksRef.current.length === 0 && !isRecording && (
              <p className="text-sm text-stone-400 text-center py-6">
                Waveform will appear after recording
              </p>
            )}
          </div>
        </div>
      </div>

      {status && <p className="text-sm text-muted-foreground border-t pt-4">{status}</p>}
    </div>
  );
}