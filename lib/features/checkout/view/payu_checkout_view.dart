import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/extension/extension.dart';
import 'package:goncook/core/router/routes.dart' show Routes;
import 'package:goncook/core/services/payu_service.dart';
import 'package:goncook/features/checkout/data/models/payu_checkout_response_model.dart';
import 'package:goncook/features/checkout/view/page_success_view.dart' show PageSuccess;
import 'package:goncook/features/checkout/widget/widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayUCheckoutWebView extends StatefulWidget {
  final String checkoutUrl;
  final Map<String, String> checkoutData;

  const PayUCheckoutWebView({
    super.key,
    required this.checkoutUrl,
    required this.checkoutData,
  });

  @override
  State<PayUCheckoutWebView> createState() => _PayUCheckoutWebViewState();
}

class _PayUCheckoutWebViewState extends State<PayUCheckoutWebView> {
  WebViewController? _webController;
  double progress = 0;
  late PayuCheckoutResponseModel responsePayU;
  bool _isSuccess = false;

  @override
  void initState() {
    responsePayU = PayuCheckoutResponseModel.empty;
    super.initState();
  }

  Future<void> _reloadCheckout() async {
    final WebViewController? c = _webController;
    if (c == null) {
      return;
    }
    await c.loadRequest(
      Uri.parse(widget.checkoutUrl),
      method: LoadRequestMethod.post,
      headers: const <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: encodePayuCheckoutBody(widget.checkoutData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isSuccess
        ? PageSuccess(
            title: context.loc.subscriptionSuccessTitle,
            content: Text(context.loc.subscriptionSuccessContent),
            confirmLabel: context.loc.goHome,
            onConfirm: () {
              if (context.mounted) {
                context.replace(Routes.home.description);
              }
            },
          )
        : CheckoutInterface(
            checkoutUrl: widget.checkoutUrl,
            checkoutData: widget.checkoutData,
            progress: progress,
            onControllerReady: (WebViewController c) {
              _webController = c;
            },
            onProgressChanged: (double p) {
              progress = p / 100.0;
              setState(() {});
            },
            onPaymentSuccess:
                (PayuCheckoutResponseModel responsePayU, Map<String, String> params) async {
              await Future<void>.delayed(const Duration(milliseconds: 3000), () {
                _processPaymentResult(
                  transactionState: responsePayU.transactionState!,
                  referenceCode: responsePayU.referenceCode ?? '',
                  transactionId: responsePayU.transactionId,
                  orderId: responsePayU.referencePol ?? '',
                  additionalData: params,
                );
                _isSuccess = true;
                setState(() {});
              });
            },
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
      final PayUService payuService = PayUService();
      final bool success = await payuService.processPaymentResponse(
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
        if (mounted) {
          _showFailureDialog(transactionState);
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorToast('Error procesando pago: $e');
      }
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
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        icon: Icon(
          transactionState == '7' ? Icons.schedule : Icons.error,
          color: transactionState == '7' ? Colors.orange : Colors.red,
          size: 48,
        ),
        title: Text(
          transactionState == '7' ? 'Pago Pendiente' : 'Pago Rechazado',
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context
                ..pop()
                ..pop();
            },
            child: const Text('Entendido'),
          ),
          if (transactionState == '6')
            ElevatedButton(
              onPressed: () {
                context.pop();
                _reloadCheckout();
              },
              child: const Text('Intentar de Nuevo'),
            ),
        ],
      ),
    );
  }
}
