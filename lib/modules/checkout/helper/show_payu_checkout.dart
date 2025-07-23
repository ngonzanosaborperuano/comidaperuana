import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/constants/payu_config.dart' show PayUConfig;
import 'package:recetasperuanas/core/services/payu_service.dart' show PayUService;
import 'package:recetasperuanas/core/services/subscription_service.dart'
    show SubscriptionPlanType, SubscriptionPricing;
import 'package:recetasperuanas/modules/checkout/view/payu_checkout_webview.dart'
    show PayUCheckoutWebView;

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
    final payuService = PayUService();

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
      final checkoutData = PayUService.buildPayUCheckoutData(
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
