import 'package:flutter/material.dart';
import 'package:goncook/src/infrastructure/shared/services/audio/audio_service.dart';
import 'package:goncook/src/infrastructure/shared/services/monitoring/monitoring_helper.dart';

/// Widget de campo de texto con funcionalidad de voz actualizado
/// Sigue el principio de responsabilidad única (SOLID)
class VoiceTextFieldUpdated extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final String? languageCode;

  const VoiceTextFieldUpdated({
    super.key,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.languageCode,
  });

  @override
  State<VoiceTextFieldUpdated> createState() => _VoiceTextFieldUpdatedState();
}

class _VoiceTextFieldUpdatedState extends State<VoiceTextFieldUpdated> {
  final TextEditingController _controller = TextEditingController();
  bool _isRecording = false;
  String _currentLanguage = 'es';

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
    _currentLanguage = widget.languageCode ?? 'es';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Inicia la grabación de voz
  Future<void> _startRecording() async {
    if (!AudioService.isInitialized) {
      _showErrorSnackBar('Servicio de audio no disponible');
      return;
    }

    try {
      setState(() {
        _isRecording = true;
      });

      // Registrar evento de monitoreo
      MonitoringHelper.logEvent(
        'voice_recording_started',
        parameters: {'language': _currentLanguage, 'timestamp': DateTime.now().toIso8601String()},
      );

      // Aquí implementarías la lógica de grabación
      // Por ahora solo simulamos
      await Future.delayed(const Duration(seconds: 2));

      // Simular resultado de grabación
      _controller.text = 'Texto grabado desde voz';
      widget.onChanged?.call(_controller.text);

      _showSuccessSnackBar('Grabación completada');
    } catch (e) {
      _showErrorSnackBar('Error al grabar: $e');

      // Registrar error de monitoreo
      MonitoringHelper.logAppError('Voice recording failed: $e');
    } finally {
      setState(() {
        _isRecording = false;
      });
    }
  }

  /// Detiene la grabación de voz
  Future<void> _stopRecording() async {
    setState(() {
      _isRecording = false;
    });

    // Registrar evento de monitoreo
    MonitoringHelper.logEvent(
      'voice_recording_stopped',
      parameters: {'language': _currentLanguage, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Escribe o graba tu mensaje...',
        suffixIcon: IconButton(
          icon: Icon(
            _isRecording ? Icons.stop : Icons.mic,
            color: _isRecording ? Colors.red : Colors.blue,
          ),
          onPressed: _isRecording ? _stopRecording : _startRecording,
        ),
        border: const OutlineInputBorder(),
      ),
      onChanged: widget.onChanged,
      maxLines: 3,
    );
  }
}
