import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:goncook/core/constants/payu_config.dart' show PayUConfig;
import 'package:goncook/features/checkout/data/models/payu_checkout_params_model.dart'
    show PayuCheckoutParamsModel;
import 'package:goncook/features/checkout/data/models/payu_response_model.dart' show PayUResponse;
import 'package:http/http.dart' as http;

import 'subscription_service.dart';

class PayUService extends ChangeNotifier {
  static final PayUService _instance = PayUService._internal();
  factory PayUService() => _instance;
  PayUService._internal();

  bool _isLoading = false;
  String? _lastError;

  // Getters
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  /// Procesar pago de suscripción (genera URL de checkout)
  Future<PayUResponse> processSubscriptionPayment({
    required SubscriptionPlanType planType,
    required double amount,
    required String userEmail,
    required String userName,
    String? phoneNumber,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      return PayUResponse(
        success: true,
        message: 'Checkout URL generado exitosamente',
        checkoutUrl: PayUConfig.checkoutUrl,
        rawData: {
          'planType': planType.id,
          'amount': amount,
          'userEmail': userEmail,
          'userName': userName,
        },
      );
    } catch (e, stackTrace) {
      _setError('Error procesando pago: $e');
      debugPrint('StackTrace: $stackTrace');
      return PayUResponse(success: false, message: e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> processPaymentResponse({
    required String referenceCode,
    required String transactionState,
    String? transactionId,
    String? orderId,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      _setLoading(true);

      // Estados de transacción de PayU:
      // 4 = APPROVED (Aprobada)
      // 6 = DECLINED (Rechazada)
      // 7 = PENDING (Pendiente)

      if (transactionState == '4') {
        // Pago aprobado - activar suscripción
        final planTypeId = additionalData?['extra1'] ?? '';
        final planType = SubscriptionPlanType.values.firstWhere(
          (type) => type.id == planTypeId,
          orElse: () => SubscriptionPlanType.monthly,
        );

        final amount = double.tryParse(additionalData?['TX_VALUE']?.toString() ?? '0') ?? 0.0;

        await SubscriptionService().activateSubscription(
          planType: planType,
          paidAmount: amount,
          transactionId: transactionId,
          metadata: {
            'paymentMethod': 'payu_checkout',
            'orderId': orderId,
            'referenceCode': referenceCode,
            'transactionState': transactionState,
            'processedAt': DateTime.now().toIso8601String(),
          },
        );

        return true;
      } else {
        _setError('Pago no aprobado. Estado: $transactionState');
        return false;
      }
    } catch (e, stackTrace) {
      _setError('Error procesando respuesta: $e');
      debugPrint('StackTrace: $stackTrace');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Consultar estado de transacción
  Future<PayUResponse> checkTransactionStatus({required String orderId}) async {
    try {
      final requestBody = {
        'language': PayUConfig.language,
        'command': 'ORDER_DETAIL',
        'merchant': {'apiKey': PayUConfig.apiKey, 'apiLogin': PayUConfig.apiLogin},
        'details': {'orderId': orderId},
      };

      final response = await http.post(
        Uri.parse('${PayUConfig.baseUrl}/payments-api/4.0/service.cgi'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return PayUResponse.fromJson(responseData);
      } else {
        throw Exception('Error consultando estado: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('StackTrace: $stackTrace');
      return PayUResponse(success: false, message: 'Error consultando transacción: $e');
    }
  }

  /// Métodos de gestión de estado
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _lastError = error;
    notifyListeners();
  }

  void _clearError() {
    _lastError = null;
    notifyListeners();
  }

  /// Generar datos para POST al WebCheckout
  static PayuCheckoutParamsModel buildPayUCheckoutData({
    required String merchantId,
    required String accountId,
    required String apiKey,
    required double amount,
    required String currency,
    required String referenceCode,
    required String description,
    required String buyerEmail,
    required String buyerName,
    required String responseUrl,
    required String confirmationUrl,
    required String paymentMethods,
    bool test = true,
  }) {
    final formattedAmount = amount.toStringAsFixed(2);
    final signatureString =
        '$apiKey~$merchantId~$referenceCode~$formattedAmount~$currency~$paymentMethods';
    final signature = md5.convert(utf8.encode(signatureString)).toString();

    debugPrint('Signature string: $signatureString');
    debugPrint('Generated signature: $signature');

    return PayuCheckoutParamsModel.fromServiceParams(
      merchantId: merchantId,
      accountId: accountId,
      description: description,
      referenceCode: referenceCode,
      paymentMethods: paymentMethods,
      amount: formattedAmount,
      currency: currency,
      signature: signature,
      test: test,
      buyerEmail: buyerEmail,
      buyerName: buyerName,
      responseUrl: responseUrl,
      confirmationUrl: confirmationUrl,
      lng: 'es',
    );
  }

  /// Método de conveniencia para obtener Map desde el modelo
  static Map<String, String> buildPayUCheckoutDataAsMap({
    required String merchantId,
    required String accountId,
    required String apiKey,
    required double amount,
    required String currency,
    required String referenceCode,
    required String description,
    required String buyerEmail,
    required String buyerName,
    required String responseUrl,
    required String confirmationUrl,
    required String paymentMethods,
    bool test = true,
  }) {
    final paramsModel = buildPayUCheckoutData(
      merchantId: merchantId,
      accountId: accountId,
      apiKey: apiKey,
      amount: amount,
      currency: currency,
      referenceCode: referenceCode,
      description: description,
      buyerEmail: buyerEmail,
      buyerName: buyerName,
      responseUrl: responseUrl,
      confirmationUrl: confirmationUrl,
      paymentMethods: paymentMethods,
      test: test,
    );

    return paramsModel.toServiceMap();
  }
}

/// Extension para obtener precios con formato PayU
extension PayUPricing on SubscriptionPlanType {
  String get payuFormattedPrice => basePrice.toStringAsFixed(1);
  String get payuDescription => 'Suscripción $displayName - GonCook';
}

/// Tarjetas de prueba para Perú (Sandbox)
class PayUTestCards {
  // Tarjetas de crédito de prueba para Perú
  static const String visaCredit = '4111111111111111';
  static const String mastercardCredit = '5555555555554444';
  static const String amexCredit = '378282246310005';

  // Tarjetas de débito de prueba para Perú
  static const String visaDebit = '4005580000000007';
  static const String mastercardDebit = '5200828282828210';

  // CVV de prueba (cualquier número de 3 dígitos)
  static const String testCvv = '123';

  // Fecha de vencimiento (cualquier fecha futura)
  static const String testExpiry = '12/25';

  // Documento de identidad de prueba
  static const String testDocument = '12345678';
}
