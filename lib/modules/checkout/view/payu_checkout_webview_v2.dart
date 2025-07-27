import 'dart:math' as math;
import 'dart:typed_data';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/modules/checkout/model/payu_checkout_response_model.dart';
import 'package:recetasperuanas/modules/checkout/widget/widget.dart' show FootPayU;
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/app_confirm_dialog.dart' show AppConfirmDialog;
import 'package:recetasperuanas/shared/widget/widget.dart';

import '../../../core/services/payu_service.dart';

class ConfettiDialogWrapper extends StatefulWidget {
  final String title;
  final Widget content;
  final String confirmLabel;
  final bool showAnimatedBorder;
  final VoidCallback onConfirm;

  const ConfettiDialogWrapper({
    super.key,
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.showAnimatedBorder,
    required this.onConfirm,
  });

  @override
  State<ConfettiDialogWrapper> createState() => _ConfettiDialogWrapperState();
}

class _ConfettiDialogWrapperState extends State<ConfettiDialogWrapper> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Forma personalizada: estrella
  Path drawStar(Size size) {
    // 5-point star
    final path = Path();
    const n = 5;
    final r = size.width / 2;
    final R = r * 2.5;
    const angle = (2 * 3.1415926) / n;
    for (int i = 0; i < n; i++) {
      final x = r + R * math.cos(i * angle);
      final y = r + R * math.sin(i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      final x2 = r + r * math.cos(i * angle + angle / 2);
      final y2 = r + r * math.sin(i * angle + angle / 2);
      path.lineTo(x2, y2);
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AppConfirmDialog(
          title: widget.title,
          content: widget.content,
          confirmLabel: widget.confirmLabel,
          showAnimatedBorder: widget.showAnimatedBorder,
          onConfirm: widget.onConfirm,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: 0.10, // ligeramente menor para menos saturación
            numberOfParticles: 36, // 10% menos que 40
            maxBlastForce: 30,
            minBlastForce: 12,
            gravity: 0.25,
            colors: const [
              Color(0xFFFFC107), // Amarillo
              Color(0xFF4CAF50), // Verde
              Color(0xFF2196F3), // Azul
              Color(0xFFF44336), // Rojo
              Color(0xFF9C27B0), // Morado
              Color(0xFFFFEB3B), // Amarillo claro
              Color(0xFF00BCD4), // Celeste
              Color(0xFFFFFFFF), // Blanco
            ],
            createParticlePath: (size) {
              final random = math.Random();
              final shape = random.nextInt(3);
              switch (shape) {
                case 0:
                  return drawStar(size);
                case 1:
                  return Path()..addOval(
                    Rect.fromCircle(
                      center: Offset(size.width / 2, size.height / 2),
                      radius: size.width / 2,
                    ),
                  );
                default:
                  return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
              }
            },
            minimumSize: const Size(8, 8),
            maximumSize: const Size(18, 18),
          ),
        ),
      ],
    );
  }
}

class PayUCheckoutWebViewV2 extends StatefulWidget {
  final String checkoutUrl;
  final Map<String, String> checkoutData;
  final VoidCallback? onPaymentCompleted;
  final VoidCallback? onPaymentFailed;

  const PayUCheckoutWebViewV2({
    super.key,
    required this.checkoutUrl,
    required this.checkoutData,
    this.onPaymentCompleted,
    this.onPaymentFailed,
  });

  @override
  State<PayUCheckoutWebViewV2> createState() => _PayUCheckoutWebViewV2State();
}

class _PayUCheckoutWebViewV2State extends State<PayUCheckoutWebViewV2> {
  InAppWebViewController? _controller;
  double progress = 0;
  late PayuCheckoutResponseModel responsePayU;
  bool _isSuccess = false;

  @override
  void initState() {
    responsePayU = PayuCheckoutResponseModel.empty;
    super.initState();
    _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(widget.checkoutUrl)));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body:
          _isSuccess
              ? ConfettiDialogWrapper(
                title: context.loc.subscriptionSuccessTitle,
                content: Text(context.loc.subscriptionSuccessContent),
                confirmLabel: context.loc.goHome,
                showAnimatedBorder: true,
                onConfirm: () {
                  if (context.mounted) context.go('/home');
                },
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 4,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: MediaQuery.of(context).size.width * progress,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [context.color.error, context.color.buttonPrimary],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    color: context.color.background,
                    width: MediaQuery.of(context).size.width,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: context.color.text),
                      onPressed: () async {
                        if (_controller != null && await _controller!.canGoBack()) {
                          _controller!.goBack();
                        } else {
                          if (!context.mounted) return;
                          context.pop();
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: WebUri(widget.checkoutUrl),
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: Uint8List.fromList(
                          widget.checkoutData.entries
                              .map(
                                (e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
                              )
                              .join('&')
                              .codeUnits,
                        ),
                      ),
                      initialSettings: InAppWebViewSettings(
                        javaScriptEnabled: true,
                        useShouldOverrideUrlLoading: true,
                        mediaPlaybackRequiresUserGesture: false,
                        domStorageEnabled: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                        useHybridComposition: true,
                        cacheEnabled: true,
                        transparentBackground: true,
                        useWideViewPort: true,
                        safeBrowsingEnabled: true,
                        loadWithOverviewMode: true,
                        hardwareAcceleration: true,
                        networkAvailable: true,
                        disallowOverScroll: true,
                        isPagingEnabled: true,
                        allowBackgroundAudioPlaying: true,
                        iframeAllow: 'fullscreen; payment',
                      ),
                      onWebViewCreated: (controller) {
                        _controller = controller;
                      },
                      onProgressChanged: (controller, p) {
                        setState(() {
                          progress = p / 100.0;
                        });
                      },
                      shouldOverrideUrlLoading: (controller, navAction) async {
                        return NavigationActionPolicy.ALLOW;
                      },
                      onConsoleMessage: (controller, consoleMessage) async {
                        if (consoleMessage.message.contains('https://cocinando.shop/api/v1/docs') &&
                            consoleMessage.message.contains('reference_pol')) {
                          final uri = Uri.parse(consoleMessage.message);
                          final params = uri.queryParameters;
                          responsePayU = PayuCheckoutResponseModel.fromJson(params);
                          await Future.delayed(const Duration(seconds: 3), () {
                            _processPaymentResult(
                              transactionState: responsePayU.transactionState!,
                              referenceCode: responsePayU.referenceCode ?? '',
                              transactionId: responsePayU.transactionId,
                              orderId: null,
                              additionalData: params,
                            );
                            setState(() {
                              _isSuccess = true;
                            });
                          });
                        }
                      },
                    ),
                  ),
                  const FootPayU(),
                ],
              ),
    );
  }

  Future<void> _processPaymentResult({
    required String transactionState,
    required String referenceCode,
    String? transactionId,
    String? orderId,
    Map<String, String>? additionalData,
  }) async {
    try {
      final payuService = PayUService();
      final success = await payuService.processPaymentResponse(
        referenceCode: referenceCode,
        transactionState: transactionState,
        transactionId: transactionId,
        orderId: orderId,
        additionalData: additionalData,
      );
      if (success) {
        _isSuccess = true;
        setState(() {});
      } else {
        _showFailureDialog(transactionState);
      }
    } catch (e, stackTrace) {
      debugPrint('StackTrace: $stackTrace');
      _showError('Error procesando pago: $e');
    }
  }

  void _showFailureDialog(String transactionState) {
    String message = 'No se pudo procesar el pago.';
    switch (transactionState) {
      case '6':
        message = 'El pago fue rechazado. Verifica los datos de tu tarjeta.';
        break;
      case '7':
        message = 'El pago está pendiente de confirmación.';
        break;
      default:
        message = 'Estado del pago: $transactionState';
    }
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            icon: Icon(
              transactionState == '7' ? Icons.schedule : Icons.error,
              color: transactionState == '7' ? Colors.orange : Colors.red,
              size: 48,
            ),
            title: Text(transactionState == '7' ? 'Pago Pendiente' : 'Pago Rechazado'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  context
                    ..pop
                    ..pop();
                },
                child: const Text('Entendido'),
              ),
              if (transactionState == '6')
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                    setState(() {
                      _controller?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(widget.checkoutUrl),
                          method: 'POST',
                          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                          body: Uint8List.fromList(
                            widget.checkoutData.entries
                                .map(
                                  (e) =>
                                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
                                )
                                .join('&')
                                .codeUnits,
                          ),
                        ),
                      );
                    });
                  },
                  child: const Text('Intentar de Nuevo'),
                ),
            ],
          ),
    );
  }

  void _showError(String error) {
    if (!mounted) return;
    context.showErrorToast(error);
  }
}
