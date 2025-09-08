import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/src/infrastructure/shared/services/payu_service.dart'
    show PayUService;
import 'package:recetasperuanas/src/infrastructure/shared/services/subscription_service.dart'
    show SubscriptionPlanType, SubscriptionPricing;
import 'package:recetasperuanas/src/shared/constants/payu_config.dart' show PayUConfig;
import 'package:recetasperuanas/src/shared/constants/routes.dart' show Routes;
import 'package:recetasperuanas/src/shared/controller/base_controller.dart';
import 'package:recetasperuanas/src/shared/widget/widget.dart';

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

    final description =
        '${context.loc.subscription} ${planType.displayName} - ${context.loc.appName}';

    // Generar URL y datos de checkout
    final response = await payuService.processSubscriptionPayment(
      planType: planType,
      amount: planType.basePrice,
      userEmail: userEmail,
      userName: userName,
      phoneNumber: phoneNumber,
    );

    if (response.success && response.checkoutUrl != null) {
      final checkoutData = PayUService.buildPayUCheckoutData(
        merchantId: PayUConfig.merchantId,
        accountId: PayUConfig.accountId,
        apiKey: PayUConfig.apiKey,
        amount: planType.basePrice,
        currency: PayUConfig.currency,
        referenceCode: 'SUB_${planType.id.toUpperCase()}_${DateTime.now().millisecondsSinceEpoch}',
        description: description,
        buyerEmail: userEmail,
        buyerName: userName,
        responseUrl: PayUConfig.responseUrl,
        confirmationUrl: PayUConfig.confirmationUrl,
        test: PayUConfig.testMode,
        paymentMethods: PayUConfig.paymentMethods,
      );

      // Mostrar WebView con checkout
      if (context.mounted) {
        // Serializar checkoutData para queryParameters
        final checkoutDataMap = checkoutData.toServiceMap();
        final checkoutDataJson = checkoutDataMap.entries
            .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
        context.goNamed(
          Routes.payuCheckout.description,
          queryParameters: {'checkoutUrl': response.checkoutUrl!, 'checkoutData': checkoutDataJson},
        );
      }
    } else {
      // Error generando checkout
      if (context.mounted) {
        context.showErrorToast(response.message ?? 'Error generando checkout');
        onFailure?.call();
      }
    }
  } catch (e, stackTrace) {
    if (context.mounted) {
      log('Error: $e', stackTrace: stackTrace);
      context.showErrorToast('Error: $e');
    }
  }
}
