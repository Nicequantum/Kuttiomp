"use client";

import { useCallback, useRef, useState } from "react";
import { Mic, Square, Upload } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { api } from "@/lib/api";
import type { Speaker } from "@kuttiomp/database";

interface AudioRecorderProps {
  speakers: Speaker[];
  lexicalEntryId?: string;
  onUploadComplete?: (result: unknown) => void;
}

export function AudioRecorder({
  speakers,
  lexicalEntryId,
  onUploadComplete,
}: AudioRecorderProps) {
  const [isRecording, setIsRecording] = useState(false);
  const [selectedSpeaker, setSelectedSpeaker] = useState<string>("");
  const [recordingContext, setRecordingContext] = useState("");
  const [status, setStatus] = useState<string>("");
  const [audioUrl, setAudioUrl] = useState<string | null>(null);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const chunksRef = useRef<Blob[]>([]);

  const startRecording = useCallback(async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const mediaRecorder = new MediaRecorder(stream, { mimeType: "audio/webm" });
      mediaRecorderRef.current = mediaRecorder;
      chunksRef.current = [];

      mediaRecorder.ondataavailable = (e) => {
        if (e.data.size > 0) chunksRef.current.push(e.data);
      };

      mediaRecorder.onstop = () => {
        const blob = new Blob(chunksRef.current, { type: "audio/webm" });
        setAudioUrl(URL.createObjectURL(blob));
        stream.getTracks().forEach((track) => track.stop());
      };

      mediaRecorder.start();
      setIsRecording(true);
      setStatus("Recording...");
    } catch {
      setStatus("Microphone access denied. Please allow microphone permissions.");
    }
  }, []);

  const stopRecording = useCallback(() => {
    mediaRecorderRef.current?.stop();
    setIsRecording(false);
    setStatus("Recording complete. Ready to upload.");
  }, []);

  const uploadRecording = useCallback(async () => {
    if (!selectedSpeaker || chunksRef.current.length === 0) {
      setStatus("Please select a speaker and record audio first.");
      return;
    }

    setStatus("Uploading...");
    const blob = new Blob(chunksRef.current, { type: "audio/webm" });
    const formData = new FormData();
    formData.append("file", blob, "recording.webm");
    formData.append("speaker_id", selectedSpeaker);
    if (lexicalEntryId) formData.append("lexical_entry_id", lexicalEntryId);
    if (recordingContext) formData.append("recording_context", recordingContext);
    formData.append("quality", "field");
    formData.append("visibility", "clan");

    try {
      const result = await api.audio.upload(formData);
      setStatus("Upload successful! Awaiting elder approval.");
      onUploadComplete?.(result);
    } catch {
      setStatus("Upload failed. Please try again.");
    }
  }, [selectedSpeaker, lexicalEntryId, recordingContext, onUploadComplete]);

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <Label>Speaker Attribution *</Label>
        <Select value={selectedSpeaker} onValueChange={setSelectedSpeaker}>
          <SelectTrigger>
            <SelectValue placeholder="Select the speaker whose voice is being recorded" />
          </SelectTrigger>
          <SelectContent>
            {speakers.map((speaker) => (
              <SelectItem key={speaker.id} value={speaker.id}>
                {speaker.display_name} — {speaker.role}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <p className="text-xs text-muted-foreground">
          Every recording must be attributed to the speaker whose voice is captured.
        </p>
      </div>

      <div className="space-y-2">
        <Label>Recording Context</Label>
        <input
          className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
          placeholder="e.g., Kitchen conversation, Formal lesson, Practice session"
          value={recordingContext}
          onChange={(e) => setRecordingContext(e.target.value)}
        />
      </div>

      <div className="flex items-center gap-4">
        {!isRecording ? (
          <Button onClick={startRecording} size="lg" className="gap-2">
            <Mic className="h-5 w-5" />
            Start Recording
          </Button>
        ) : (
          <Button onClick={stopRecording} variant="destructive" size="lg" className="gap-2">
            <Square className="h-5 w-5" />
            Stop Recording
          </Button>
        )}

        {audioUrl && (
          <Button onClick={uploadRecording} variant="secondary" className="gap-2">
            <Upload className="h-4 w-4" />
            Upload with Attribution
          </Button>
        )}
      </div>

      {audioUrl && (
        <audio controls src={audioUrl} className="w-full" />
      )}

      {status && (
        <p className="text-sm text-muted-foreground">{status}</p>
      )}
    </div>
  );
}