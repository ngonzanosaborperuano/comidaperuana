import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/checkout/widget/widget.dart' show FootPayU;
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/services/payu_service.dart';

/// Widget WebView para checkout de PayU
class PayUCheckoutWebView extends StatefulWidget {
  final String checkoutUrl;
  final Map<String, String> checkoutData;
  final VoidCallback? onPaymentCompleted;
  final VoidCallback? onPaymentFailed;
  final VoidCallback? onCancel;
  final Color background;

  const PayUCheckoutWebView({
    super.key,
    required this.checkoutUrl,
    required this.checkoutData,
    required this.background,
    this.onPaymentCompleted,
    this.onPaymentFailed,
    this.onCancel,
  });

  @override
  State<PayUCheckoutWebView> createState() => _PayUCheckoutWebViewState();
}

class _PayUCheckoutWebViewState extends State<PayUCheckoutWebView> {
  late WebViewController _controller;

  bool _hasProcessedPayment = false;
  ValueNotifier progress = ValueNotifier<int>(0);
  ValueNotifier showBackButton = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  @override
  void dispose() {
    _controller.clearCache();
    _controller.clearLocalStorage();
    super.dispose();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(widget.background)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                debugPrint('🌐 PAYU - Página cargando: $url');
                _checkPaymentResponse(url);
              },
              onPageFinished: (String url) {
                debugPrint('✅ PAYU - Página cargada: $url');
              },
              onHttpError: (HttpResponseError error) {
                debugPrint('❌ PAYU - Error HTTP: ${error.response?.statusCode}');
                //_showError('Error de conexión: ${error.response?.statusCode}');
              },
              onWebResourceError: (WebResourceError error) {
                debugPrint('❌ PAYU - Error de recurso: ${error.description} - ${error.url}');
                //_showError('Error cargando página: ${error.description}');
              },
              onNavigationRequest: (NavigationRequest request) {
                debugPrint('🔄 PAYU - Navegación solicitada: ${request.url}');
                return NavigationDecision.navigate;
              },
              onSslAuthError: (SslAuthError error) {
                debugPrint('❌ PAYU - Error de SSL: ${error.certificate} - ${error.platform}');
                //_showError('Error de SSL: ${error.description}');
              },
              onProgress: (int progreso) {
                progress.value = progreso;
                setState(() {});
              },
            ),
          )
          ..loadRequest(
            Uri.parse(widget.checkoutUrl),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            method: LoadRequestMethod.post,
            body: Uint8List.fromList(
              widget.checkoutData.entries
                  .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                  .join('&')
                  .codeUnits,
            ),
          )
          ..setBackgroundColor(widget.background);
  }

  /// Verificar respuesta de PayU en la URL
  void _checkPaymentResponse(String url) {
    if (_hasProcessedPayment) return;

    debugPrint('🔍 PAYU - Verificando URL: $url');

    // URLs de respuesta de PayU contienen parámetros del resultado
    if (url.contains('webhook') || url.contains('payu') && url.contains('response')) {
      debugPrint('🎯 PAYU - URL de respuesta detectada!');

      final uri = Uri.parse(url);
      final params = uri.queryParameters;

      debugPrint('📋 PAYU - Parámetros de respuesta: $params');

      final transactionState = params['transactionState'];
      final referenceCode = params['referenceCode'];
      final transactionId = params['transactionId'];
      final orderId = params['orderId'];

      if (transactionState != null && referenceCode != null) {
        debugPrint('✅ PAYU - Procesando resultado: Estado=$transactionState, Ref=$referenceCode');
        _hasProcessedPayment = true;
        _processPaymentResult(
          transactionState: transactionState,
          referenceCode: referenceCode,
          transactionId: transactionId,
          orderId: orderId,
          additionalData: params,
        );
      } else {
        debugPrint('⚠️ PAYU - URL de respuesta sin parámetros requeridos');
      }
    } else {
      debugPrint('ℹ️ PAYU - URL no es de respuesta de pago');
    }
  }

  /// Procesar resultado del pago
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
        showBackButton.value = false;
        _showSuccessDialog();
      } else {
        _showFailureDialog(transactionState);
      }
    } catch (e, stackTrace) {
      debugPrint('StackTrace: $stackTrace');
      _showError('Error procesando pago: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
            title: const Text('¡Pago Exitoso!'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tu suscripción ha sido activada correctamente.'),
                SizedBox(height: 8),
                Text(
                  '🎉 ¡Bienvenido a Premium!\nYa puedes disfrutar de todas las funcionalidades.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  context.go(Routes.home.description);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('¡Continuar!'),
              ),
            ],
          ),
    );
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
                  widget.onPaymentFailed?.call();
                },
                child: const Text('Entendido'),
              ),
              if (transactionState == '6') // Solo si fue rechazado
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                    setState(() {
                      _hasProcessedPayment = false;
                      _controller.loadRequest(
                        Uri.parse(widget.checkoutUrl),
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        method: LoadRequestMethod.post,
                        body: Uint8List.fromList(
                          widget.checkoutData.entries
                              .map(
                                (e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
                              )
                              .join('&')
                              .codeUnits,
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable: showBackButton,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return !value
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () async {
                      // Verifica si hay historial para volver atrás
                      if (await _controller.canGoBack()) {
                        _controller.goBack();
                      } else {
                        if (!context.mounted) return;
                        context.pop();
                      }
                    },
                  )
                  : const SizedBox.shrink();
            },
          ),
          SizedBox(
            height: 4,
            child: ValueListenableBuilder(
              valueListenable: progress,
              builder: (context, value, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width * (value / 100),
                  decoration: BoxDecoration(gradient: context.color.primaryGradient),
                );
              },
            ),
          ),
          Expanded(child: WebViewWidget(controller: _controller)),
          const FootPayU(),
        ],
      ),
    );
  }
}
