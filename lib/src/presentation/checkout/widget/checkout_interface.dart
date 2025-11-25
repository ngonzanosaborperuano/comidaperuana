import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List;
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    show
        InAppWebViewController,
        InAppWebView,
        WebUri,
        URLRequest,
        InAppWebViewSettings,
        NavigationActionPolicy;
import 'package:go_router/go_router.dart';
import 'package:goncook/src/presentation/checkout/models/payu_checkout_response_model.dart';
import 'package:goncook/src/presentation/checkout/widget/widget.dart';
import 'package:goncook/src/shared/controller/base_controller.dart';
import 'package:goncook/src/shared/widget/widget.dart';

class CheckoutInterface extends StatefulWidget {
  final String checkoutUrl;
  final Map<String, String> checkoutData;
  final double progress;
  final Function(double) onProgressChanged;
  final Function(PayuCheckoutResponseModel, Map<String, String>) onPaymentSuccess;

  const CheckoutInterface({
    super.key,
    required this.checkoutUrl,
    required this.checkoutData,
    required this.progress,
    required this.onProgressChanged,
    required this.onPaymentSuccess,
  });

  @override
  State<CheckoutInterface> createState() => _CheckoutInterfaceState();
}

class _CheckoutInterfaceState extends State<CheckoutInterface> {
  InAppWebViewController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: kToolbarHeight),
        SizedBox(
          height: 4,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width * widget.progress,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [context.color.error, context.color.buttonPrimary]),
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
                    .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
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
              widget.onProgressChanged(p.toDouble());
            },
            shouldOverrideUrlLoading: (controller, navAction) async {
              debugPrint('navAction: ${navAction.request.url}');
              return NavigationActionPolicy.ALLOW;
            },
            onConsoleMessage: (controller, consoleMessage) async {
              if (consoleMessage.message.contains('https://cocinando.shop') &&
                  consoleMessage.message.contains('reference_pol')) {
                final uri = Uri.parse(consoleMessage.message);
                final params = uri.queryParameters;
                final responsePayU = PayuCheckoutResponseModel.fromJson(params);
                if (responsePayU.transactionState == '4') {
                  widget.onPaymentSuccess(responsePayU, params);
                } else if (responsePayU.transactionState == '6') {
                  if (mounted) {
                    context.showErrorToast(context.loc.payuError);
                  }
                }
              }
            },
          ),
        ),
        const FootPayU(),
      ],
    );
  }
}
