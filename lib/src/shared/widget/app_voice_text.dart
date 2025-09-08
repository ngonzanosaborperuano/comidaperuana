import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recetasperuanas/src/presentation/core/bloc/locale_bloc.dart';
import 'package:recetasperuanas/src/presentation/core/config/config.dart' show AppColors, AppStyles;
import 'package:recetasperuanas/src/shared/controller/base_controller.dart';
import 'package:recetasperuanas/src/shared/widget/widget.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

final _logger = Logger('VoiceTextField');

class VoiceTextField extends StatefulWidget {
  const VoiceTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.validator,
    this.onChanged,
    this.maxLength,
    this.onSaved,
    this.onFieldSubmitted,
    this.onListeningChanged,
    this.tight = false,
    this.maxLines,
    this.enabled,
  }) : fillColor = AppColors.transparent;

  const VoiceTextField.white({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.validator,
    this.onChanged,
    this.maxLength,
    this.onSaved,
    this.onFieldSubmitted,
    this.onListeningChanged,
    this.tight = false,
    this.maxLines,
    this.enabled,
  }) : fillColor = AppColors.white;

  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue;
  final int? maxLength;
  final bool tight;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String?)? onFieldSubmitted;
  final ValueChanged<bool>? onListeningChanged; // Callback para cambios en el estado de grabación
  final Color? fillColor;
  final int? maxLines;
  final bool? enabled;

  @override
  VoiceTextFieldState createState() => VoiceTextFieldState();
}

class VoiceTextFieldState extends State<VoiceTextField> {
  late TextEditingController _controller;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechEnabled = false;
  String _recordedAudio = '';

  @override
  void initState() {
    Logger('VoiceTextField').info('initState ${widget.controller?.text}');
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      // Verificar estado actual del permiso
      var status = await Permission.microphone.status;
      _logger.info('Estado inicial del micrófono: $status');

      // Si no está concedido, solicitar permiso
      if (status.isGranted) {
        _logger.info('Solicitando permiso de micrófono...');
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          _logger.info('Solicitando permiso en iOS...');
          status = await Permission.microphone.request();
        } else {
          status = await Permission.microphone.request();
        }

        _logger.info('Resultado de la solicitud: $status');
      }

      // Solo inicializar si el permiso está concedido
      if (status.isGranted) {
        _logger.info('Permiso concedido, inicializando speech-to-text...');
        _speechEnabled = await _speech.initialize(
          onStatus: (status) {
            _logger.info('Speech status: $status');
            // Solo reiniciar si realmente se detuvo inesperadamente
            if (status == 'notListening' && _isListening && _recordedAudio.isEmpty) {
              _logger.info('🔄 Reiniciando grabación por detención inesperada...');
              _startListening();
            }
          },
          onError: (error) {
            _logger.warning('Speech error: $error');
          },
        );
        _logger.info('Speech-to-text inicializado: $_speechEnabled');

        // Verificar idiomas disponibles después de la inicialización
        if (_speechEnabled) {
          try {
            final locales = await _speech.locales();
            final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
            _logger.info(
              '🌍 Idioma del dispositivo: ${deviceLocale.languageCode}_${deviceLocale.countryCode}',
            );

            // Buscar idioma del dispositivo
            final deviceLanguageMatch = locales
                .where((locale) => locale.localeId.startsWith('${deviceLocale.languageCode}_'))
                .firstOrNull;

            if (deviceLanguageMatch != null) {
              _logger.info('✅ Idioma del dispositivo disponible: ${deviceLanguageMatch.localeId}');
            } else {
              _logger.warning('⚠️ Idioma del dispositivo no disponible');
            }

            // Mostrar idiomas españoles disponibles
            final spanishLocales = locales
                .where((locale) => locale.localeId.startsWith('es_'))
                .toList();
            if (spanishLocales.isNotEmpty) {
              _logger.info(
                '🇪🇸 Idiomas españoles disponibles: ${spanishLocales.map((l) => l.localeId).join(', ')}',
              );
            }

            _logger.info('📋 Total de idiomas disponibles: ${locales.length}');
          } catch (e) {
            _logger.warning('Error al verificar idiomas disponibles: $e');
          }
        }
      } else if (status.isPermanentlyDenied) {
        _logger.warning('Permiso de micrófono denegado permanentemente');
        _speechEnabled = false;

        // En iOS, mostrar instrucciones específicas
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          _showIOSMicrophoneSettingsDialog();
        } else {
          _showMicrophoneSettingsDialog();
        }
      } else {
        _logger.warning('Permiso de micrófono denegado: $status');
        _speechEnabled = false;
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _logger.severe('Error en _initSpeech: $e');
      _speechEnabled = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _startListening() async {
    if (_isListening) {
      _logger.info('Ya está grabando, ignorando nueva solicitud');
      return;
    }

    if (!_speechEnabled) {
      _logger.info('El reconocimiento de voz no está habilitado. Solicitando permisos...');
      await _initSpeech(); // Solicita permisos automáticamente
      if (!_speechEnabled) {
        _logger.warning('No se pudo habilitar el reconocimiento de voz.');
        return;
      }
    }

    try {
      _recordedAudio = ''; // Reiniciar la grabación anterior
      _isListening = true;
      setState(() {});
      _notifyListeningState(true); // Notificar que comenzó a grabar

      // Usar el idioma del LocaleBloc
      String? localeToUse;
      try {
        final locales = await _speech.locales();
        final localeState = context.read<LocaleBloc>().state;
        final appLocale = localeState is LocaleLoaded ? localeState.locale : const Locale('es');

        _logger.info('🌍 Idioma de la app: ${appLocale.languageCode}');

        // Buscar idioma según el LocaleProvider
        if (appLocale.languageCode == 'es') {
          // Para español, buscar la mejor variante disponible
          localeToUse =
              locales.where((locale) => locale.localeId == 'es_ES').firstOrNull?.localeId ??
              locales.where((locale) => locale.localeId == 'es_MX').firstOrNull?.localeId ??
              locales.where((locale) => locale.localeId == 'es_PE').firstOrNull?.localeId ??
              locales.where((locale) => locale.localeId.startsWith('es_')).firstOrNull?.localeId;

          if (localeToUse != null) {
            _logger.info('🇪🇸 Usando idioma español: $localeToUse');
          }
        } else if (appLocale.languageCode == 'en') {
          // Para inglés, buscar la mejor variante disponible
          localeToUse =
              locales.where((locale) => locale.localeId == 'en_US').firstOrNull?.localeId ??
              locales.where((locale) => locale.localeId == 'en_GB').firstOrNull?.localeId ??
              locales.where((locale) => locale.localeId.startsWith('en_')).firstOrNull?.localeId;

          if (localeToUse != null) {
            _logger.info('🇺🇸 Usando idioma inglés: $localeToUse');
          }
        }

        if (localeToUse == null) {
          _logger.warning(
            '⚠️ No se encontró idioma compatible para ${appLocale.languageCode}, usando idioma por defecto',
          );
        }

        _logger.info('📋 Idiomas disponibles: ${locales.map((l) => l.localeId).join(', ')}');
      } catch (e) {
        _logger.warning('Error al obtener idioma del LocaleProvider: $e');
      }

      await _speech.listen(
        pauseFor: const Duration(seconds: 10), // Aumentar tiempo de pausa
        listenFor: const Duration(seconds: 60), // Limitar tiempo total
        localeId: localeToUse, // Usar el idioma español detectado
        onResult: (result) {
          _logger.info('Texto reconocido: ${result.recognizedWords}');
          _recordedAudio = result.recognizedWords; // Acumula pero no transcribe aún
        },
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
          autoPunctuation: true,
          enableHapticFeedback: true,
        ),
      );
    } catch (e) {
      _logger.severe('Error al iniciar grabación: $e');
      _isListening = false;
      setState(() {});
      _notifyListeningState(false); // Notificar que hubo error
    }
  }

  void _stopListening() {
    if (!_isListening) {
      _logger.info('No está grabando, ignorando solicitud de detener');
      return;
    }

    try {
      _speech.stop();
      _isListening = false;
      setState(() {});
      _notifyListeningState(false); // Notificar que se detuvo la grabación
      _transcribeAudio(); // Transcribe cuando se detiene la grabación
      _logger.info('Grabación detenida y transcrita');
    } catch (e) {
      _logger.severe('Error al detener grabación: $e');
      _isListening = false;
      setState(() {});
      _notifyListeningState(false); // Notificar que hubo error
    }
  }

  void _transcribeAudio() {
    if (_recordedAudio.isNotEmpty) {
      setState(() {
        _controller.text += '$_recordedAudio '; // Agrega el texto grabado
        widget.onChanged?.call(_controller.text);
        _recordedAudio = ''; // Limpia la grabación para la próxima
      });
    }
  }

  void _notifyListeningState(bool isListening) {
    widget.onListeningChanged?.call(isListening);
  }

  void _showMicrophoneSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Micrófono Deshabilitado'),
          content: const Text(
            'El micrófono está deshabilitado en tu dispositivo. '
            'Para usar el reconocimiento de voz, necesitas habilitarlo en la configuración.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // Abre la configuración de la app
              },
              child: const Text('Abrir Configuración'),
            ),
          ],
        );
      },
    );
  }

  void _showIOSMicrophoneSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permiso de Micrófono Requerido'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Esta aplicación necesita acceso al micrófono para grabar audio. '
                'En iOS, debes habilitar manualmente este permiso.',
              ),
              SizedBox(height: 16),
              Text('Pasos para habilitar:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('1. Ve a Configuración > Privacidad y Seguridad'),
              Text('2. Toca en "Micrófono"'),
              Text('3. Busca "Cocinando" en la lista'),
              Text('4. Habilita el interruptor'),
              SizedBox(height: 16),
              Text(
                'Después de habilitar, reinicia la aplicación.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Ir a Configuración'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.fillColor ?? AppColors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              enabled: widget.enabled,
              maxLength: widget.maxLength,
              style: AppStyles.bodyText,
              controller: _controller,
              validator: widget.validator,
              onChanged: widget.onChanged,
              onSaved: widget.onSaved,
              onFieldSubmitted: widget.onFieldSubmitted ?? widget.onSaved,
              textInputAction: TextInputAction.search, // Botón "Buscar" en teclado móvil
              maxLines: widget.maxLines,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppStyles.bodyHintText,
                alignLabelWithHint: true,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.transparent),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.transparent),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.transparent),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                fillColor: widget.fillColor ?? AppColors.transparent,
              ),
            ),
          ),
          GestureDetector(
            onTapDown: (_) => _startListening(),
            onTapUp: (_) => _stopListening(),
            onTapCancel: () => _stopListening(),
            child: context.svgIcon(
              SvgIcons.microphone,
              color: _isListening ? context.color.error : context.color.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _speech.stop();
    super.dispose();
  }
}
