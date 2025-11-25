import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:goncook/src/infrastructure/shared/services/gemini_ai_service.dart';
import 'package:goncook/src/infrastructure/shared/services/remote_config_service.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

class AppGeminiVoiceToTextButton extends StatefulWidget {
  final void Function(String text)? onResult;

  const AppGeminiVoiceToTextButton({super.key, this.onResult});

  @override
  State<AppGeminiVoiceToTextButton> createState() => _AppGeminiVoiceToTextButtonState();
}

class _AppGeminiVoiceToTextButtonState extends State<AppGeminiVoiceToTextButton> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  late final String _filePath;
  final _loggrer = Logger('VoiceToTextButton');

  @override
  void initState() {
    super.initState();
    _filePath = '${Directory.systemTemp.path}/audio0.m4a';
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    if (_recorder.isRecording) return;

    await _recorder.startRecorder(toFile: _filePath, codec: Codec.aacMP4);

    setState(() => _isRecording = true);
  }

  // Stream<String> runFeatureFlagFlow({required InlineDataPart audioPart}) async* {
  //   final configService = RemoteConfigService();
  //   await configService.initialize();

  //   final aiService = GeminiAIService(configService);

  //   await for (final textChunk in aiService.generateAudioTextStream(audioPart: audioPart)) {
  //     yield textChunk;
  //   }
  // }
  Future<String> runFeatureFlagFlow({required InlineDataPart audioPart}) async {
    final configService = RemoteConfigService();
    await configService.initialize();

    final aiService = GeminiAIService(configService);

    return aiService.generateAudioText(audioPart: audioPart);
  }

  Future<void> _stopAndSend() async {
    await _recorder.stopRecorder();
    setState(() => _isRecording = false);

    final audioFile = File(_filePath);
    final audioBytes = await audioFile.readAsBytes();

    if (audioBytes.isEmpty) {
      _loggrer.info("❌ El archivo de audio está vacío");
      return;
    }

    final audioPart = InlineDataPart('audio/aac', audioBytes);
    final response = await runFeatureFlagFlow(audioPart: audioPart);
    widget.onResult!(response);

    // final stream = runFeatureFlagFlow(audioPart: audioPart);
    // await for (final chunk in stream) {
    //   widget.onResult!(chunk);
    // }

    // Verificar si el archivo existe antes de eliminarlo
    if (await audioFile.exists()) {
      await audioFile.delete();
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    // Verificar si el archivo existe antes de eliminarlo
    final audioFile = File(_filePath);
    if (audioFile.existsSync()) {
      try {
        audioFile.deleteSync();
      } catch (e) {
        _loggrer.warning('Error al eliminar archivo de audio: $e');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startRecording(),
      onLongPressEnd: (_) => _stopAndSend(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
        decoration: BoxDecoration(
          color: _isRecording ? Colors.red : Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _isRecording ? '🎙 Grabando... suelta para enviar' : '🎤 Mantén presionado para grabar',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
