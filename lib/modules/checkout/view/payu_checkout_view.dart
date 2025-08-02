import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/constants/routes.dart' show Routes;
import 'package:recetasperuanas/modules/checkout/model/payu_checkout_response_model.dart';
import 'package:recetasperuanas/modules/checkout/view/page_success_view.dart' show PageSuccess;
import 'package:recetasperuanas/modules/checkout/widget/widget.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

import '../../../core/services/payu_service.dart';

class PayUCheckoutWebView extends StatefulWidget {
  final String checkoutUrl;
  final Map<String, String> checkoutData;

  const PayUCheckoutWebView({super.key, required this.checkoutUrl, required this.checkoutData});

  @override
  State<PayUCheckoutWebView> createState() => _PayUCheckoutWebViewState();
}

class _PayUCheckoutWebViewState extends State<PayUCheckoutWebView> {
  InAppWebViewController? _controller;
  double progress = 0;
  late PayuCheckoutResponseModel responsePayU;
  bool _isSuccess = false;

  @override
  void initState() {
    responsePayU = PayuCheckoutResponseModel.empty;
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isSuccess
        ? PageSuccess(
          title: context.loc.subscriptionSuccessTitle,
          content: Text(context.loc.subscriptionSuccessContent),
          confirmLabel: context.loc.goHome,
          onConfirm: () {
            if (context.mounted) context.replace(Routes.home.description);
          },
        )
        : CheckoutInterface(
          checkoutUrl: widget.checkoutUrl,
          checkoutData: widget.checkoutData,
          progress: progress,
          onProgressChanged: (p) {
            progress = p / 100.0;
            setState(() {});
          },
          onPaymentSuccess: (responsePayU, params) async {
            await Future.delayed(const Duration(milliseconds: 3000), () {
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
}
