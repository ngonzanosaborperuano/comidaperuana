import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/services/payu_google_pay_service.dart';
import '../../../core/services/subscription_service.dart';

/// Widget WebView para checkout de PayU
class PayUCheckoutWebView extends StatefulWidget {
  final String checkoutUrl;
  final Map<String, String> checkoutData;
  final VoidCallback? onPaymentCompleted;
  final VoidCallback? onPaymentFailed;
  final VoidCallback? onCancel;

  const PayUCheckoutWebView({
    super.key,
    required this.checkoutUrl,
    required this.checkoutData,
    this.onPaymentCompleted,
    this.onPaymentFailed,
    this.onCancel,
  });

  @override
  State<PayUCheckoutWebView> createState() => _PayUCheckoutWebViewState();
}

class _PayUCheckoutWebViewState extends State<PayUCheckoutWebView> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _hasProcessedPayment = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() => _isLoading = true);
                _checkPaymentResponse(url);
              },
              onPageFinished: (String url) {
                setState(() => _isLoading = false);
              },
              onHttpError: (HttpResponseError error) {
                _showError('Error de conexión: ${error.response?.statusCode}');
              },
              onWebResourceError: (WebResourceError error) {
                _showError('Error cargando página: ${error.description}');
              },
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
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
          );
  }

  /// Verificar respuesta de PayU en la URL
  void _checkPaymentResponse(String url) {
    if (_hasProcessedPayment) return;

    // URLs de respuesta de PayU contienen parámetros del resultado
    if (url.contains('tu-app.com/response') || url.contains('payu') && url.contains('response')) {
      final uri = Uri.parse(url);
      final params = uri.queryParameters;

      final transactionState = params['transactionState'];
      final referenceCode = params['referenceCode'];
      final transactionId = params['transactionId'];
      final orderId = params['orderId'];

      if (transactionState != null && referenceCode != null) {
        _hasProcessedPayment = true;
        _processPaymentResult(
          transactionState: transactionState,
          referenceCode: referenceCode,
          transactionId: transactionId,
          orderId: orderId,
          additionalData: params,
        );
      }
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
      final payuService = PayUGooglePayService();

      final success = await payuService.processPaymentResponse(
        referenceCode: referenceCode,
        transactionState: transactionState,
        transactionId: transactionId,
        orderId: orderId,
        additionalData: additionalData,
      );

      if (success) {
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
                  Navigator.pop(context); // Cerrar diálogo
                  Navigator.pop(context); // Cerrar WebView
                  widget.onPaymentCompleted?.call();
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
                  Navigator.pop(context); // Cerrar diálogo
                  Navigator.pop(context); // Cerrar WebView
                  widget.onPaymentFailed?.call();
                },
                child: const Text('Entendido'),
              ),
              if (transactionState == '6') // Solo si fue rechazado
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar diálogo
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Seguro'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
            widget.onCancel?.call();
          },
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Información de seguridad
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.green[50],
            child: const Row(
              children: [
                Icon(Icons.security, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '🔒 Checkout seguro de PayU • Google Pay disponible',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),

          // WebView
          Expanded(child: WebViewWidget(controller: _controller)),

          // Footer con información
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Procesado por PayU • SSL Seguro',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Función helper para mostrar el checkout
void showPayUCheckout(
  BuildContext context, {
  required SubscriptionPlanType planType,
  required String userEmail,
  required String userName,
  String? phoneNumber,
  VoidCallback? onSuccess,
  VoidCallback? onFailure,
}) async {
  try {
    final payuService = PayUGooglePayService();

    // Generar URL y datos de checkout
    final response = await payuService.processSubscriptionPayment(
      planType: planType,
      amount: planType.basePrice,
      userEmail: userEmail,
      userName: userName,
      phoneNumber: phoneNumber,
    );

    if (response.success && response.checkoutUrl != null) {
      // Generar datos para POST
      final checkoutData = PayUGooglePayService.buildPayUCheckoutData(
        merchantId: PayUConfig.merchantId,
        accountId: PayUConfig.accountId,
        apiKey: PayUConfig.apiKey,
        amount: planType.basePrice,
        currency: PayUConfig.currency,
        referenceCode: 'SUB_${planType.id.toUpperCase()}_${DateTime.now().millisecondsSinceEpoch}',
        description: 'Suscripción ${planType.displayName} - Recetas Peruanas',
        buyerEmail: userEmail,
        buyerName: userName,
        responseUrl: PayUConfig.responseUrl,
        confirmationUrl: PayUConfig.confirmationUrl,
        test: PayUConfig.testMode,
      );

      // Mostrar WebView con checkout
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PayUCheckoutWebView(
                  checkoutUrl: response.checkoutUrl!,
                  checkoutData: checkoutData,
                  onPaymentCompleted: onSuccess,
                  onPaymentFailed: onFailure,
                ),
          ),
        );
      }
    } else {
      // Error generando checkout
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Error generando checkout'),
            backgroundColor: Colors.red,
          ),
        );
        onFailure?.call();
      }
    }
  } catch (e, stackTrace) {
    if (context.mounted) {
      print('Error: $e');
      debugPrint('StackTrace: $stackTrace');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      onFailure?.call();
    }
  }
}
