import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceToTextButton extends StatefulWidget {
  final void Function(String text)? onResult;

  const VoiceToTextButton({super.key, this.onResult});

  @override
  State<VoiceToTextButton> createState() => _VoiceToTextButtonState();
}

class _VoiceToTextButtonState extends State<VoiceToTextButton> {
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

  Future<void> _stopAndSend() async {
    await _recorder.stopRecorder();
    setState(() => _isRecording = false);

    final audioFile = File(_filePath);
    final audioBytes = await audioFile.readAsBytes();

    if (audioBytes.isEmpty) {
      _loggrer.info("❌ El archivo de audio está vacío");
      return;
    }

    final model = FirebaseAI.googleAI(
      appCheck: FirebaseAppCheck.instance,
    ).generativeModel(model: 'gemini-2.0-flash');

    final prompt = TextPart(
      "transcribe lo que escuchas y responde el audio en español. ten en cuenta que se preguntara sobre comidas, bebidas y recetas del peru y la respuesta debe ser detallada.",
    );
    final audioPart = InlineDataPart('audio/aac', audioBytes);

    final response = model.generateContentStream([
      Content.multi([prompt, audioPart]),
    ]);
    await for (final chunk in response) {
      widget.onResult!(chunk.text!);
    }

    // final resultText = response.text ?? 'Sin respuesta';

    // if (widget.onResult != null) {
    //   widget.onResult!(resultText);
    // }
    audioFile.delete();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    if (File(_filePath).existsSync()) {
      File(_filePath).deleteSync();
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
