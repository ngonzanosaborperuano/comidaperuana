import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/extension/extension.dart';
import 'package:goncook/features/checkout/data/models/payu_checkout_response_model.dart';
import 'package:goncook/features/checkout/widget/widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Codifica el cuerpo POST x-www-form-urlencoded para PayU.
Uint8List encodePayuCheckoutBody(Map<String, String> checkoutData) {
  final String encoded = checkoutData.entries
      .map(
        (MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
      )
      .join('&');
  return Uint8List.fromList(encoded.codeUnits);
}

class CheckoutInterface extends StatefulWidget {
  final String checkoutUrl;
  final Map<String, String> checkoutData;
  final double progress;
  final void Function(double) onProgressChanged;
  final void Function(PayuCheckoutResponseModel, Map<String, String>)
      onPaymentSuccess;
  final void Function(WebViewController controller)? onControllerReady;

  const CheckoutInterface({
    super.key,
    required this.checkoutUrl,
    required this.checkoutData,
    required this.progress,
    required this.onProgressChanged,
    required this.onPaymentSuccess,
    this.onControllerReady,
  });

  @override
  State<CheckoutInterface> createState() => _CheckoutInterfaceState();
}

class _CheckoutInterfaceState extends State<CheckoutInterface> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    final WebViewController controller = WebViewController();
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setBackgroundColor(Colors.transparent);
    await controller.setOnConsoleMessage(_onConsoleMessage);
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int p) => widget.onProgressChanged(p.toDouble()),
        onNavigationRequest: (NavigationRequest request) async {
          debugPrint('navAction: ${request.url}');
          return NavigationDecision.navigate;
        },
      ),
    );
    await controller.loadRequest(
      Uri.parse(widget.checkoutUrl),
      method: LoadRequestMethod.post,
      headers: const <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: encodePayuCheckoutBody(widget.checkoutData),
    );
    if (!mounted) {
      return;
    }
    setState(() => _controller = controller);
    widget.onControllerReady?.call(controller);
  }

  void _onConsoleMessage(JavaScriptConsoleMessage message) {
    final String text = message.message;
    if (text.contains('https://cocinando.shop') &&
        text.contains('reference_pol')) {
      final Uri uri = Uri.parse(text);
      final Map<String, String> params = uri.queryParameters;
      final PayuCheckoutResponseModel responsePayU =
          PayuCheckoutResponseModel.fromJson(params);
      if (responsePayU.transactionState == '4') {
        widget.onPaymentSuccess(responsePayU, params);
      } else if (responsePayU.transactionState == '6') {
        if (mounted) {
          context.showErrorToast(context.loc.payuError);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: kToolbarHeight),
        SizedBox(
          height: 4,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: MediaQuery.sizeOf(context).width * widget.progress,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  context.color.error,
                  context.color.buttonPrimary,
                ],
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          color: context.color.background,
          width: MediaQuery.sizeOf(context).width,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: context.color.text),
            onPressed: () async {
              if (_controller != null && await _controller!.canGoBack()) {
                await _controller!.goBack();
              } else {
                if (!context.mounted) {
                  return;
                }
                context.pop();
              }
            },
          ),
        ),
        Expanded(
          child: _controller == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: context.color.buttonPrimary,
                  ),
                )
              : WebViewWidget(controller: _controller!),
        ),
        const FootPayU(),
      ],
    );
  }
}
