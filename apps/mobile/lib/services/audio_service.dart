import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';

/// Audio recording and playback for field capture with speaker attribution.
class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  String? _currentPath;
  bool _isRecording = false;

  bool get isRecording => _isRecording;
  String? get currentRecordingPath => _currentPath;

  Future<bool> hasPermission() => _recorder.hasPermission();

  Future<void> startRecording({String? filePath}) async {
    if (!await hasPermission()) {
      throw Exception('Microphone permission denied');
    }
    _currentPath = filePath ?? 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: _currentPath!,
    );
    _isRecording = true;
  }

  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    _isRecording = false;
    return path ?? _currentPath;
  }

  Future<void> play(String path) async {
    await _player.stop();
    await _player.play(DeviceFileSource(path));
  }

  Future<void> stopPlayback() => _player.stop();

  Future<void> dispose() async {
    await _recorder.dispose();
    await _player.dispose();
  }
}