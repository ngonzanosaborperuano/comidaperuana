import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterState;
import 'package:goncook/src/presentation/checkout/view/payu_checkout_view.dart'
    show PayUCheckoutWebView;
import 'package:goncook/src/shared/widget/widget.dart';

class PayUCheckoutWebPage extends StatefulWidget {
  final String checkoutUrl;
  final Map<String, String> checkoutData;

  const PayUCheckoutWebPage({super.key, required this.checkoutUrl, required this.checkoutData});

  factory PayUCheckoutWebPage.routeBuilder(_, GoRouterState state) {
    final checkoutUrl = state.uri.queryParameters['checkoutUrl'];
    final checkoutDataJson = state.uri.queryParameters['checkoutData'];

    if (checkoutUrl == null || checkoutDataJson == null) {
      throw ArgumentError('Missing required checkoutUrl or checkoutData in query parameters');
    }

    // Deserializar checkoutData desde queryParameters
    final checkoutData = <String, String>{};
    final pairs = checkoutDataJson.split('&');
    for (final pair in pairs) {
      final keyValue = pair.split('=');
      if (keyValue.length == 2) {
        checkoutData[Uri.decodeComponent(keyValue[0])] = Uri.decodeComponent(keyValue[1]);
      }
    }
    return PayUCheckoutWebPage(
      key: const Key('payu_checkout_web_page'),
      checkoutUrl: checkoutUrl,
      checkoutData: checkoutData,
    );
  }
  @override
  State<PayUCheckoutWebPage> createState() => _PayUCheckoutWebPageState();
}

class _PayUCheckoutWebPageState extends State<PayUCheckoutWebPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      toolbarHeight: 0,
      body: PayUCheckoutWebView(checkoutUrl: widget.checkoutUrl, checkoutData: widget.checkoutData),
    );
  }
}
