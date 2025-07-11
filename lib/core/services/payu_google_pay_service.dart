import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'subscription_service.dart';

/// Configuración de PayU
class PayUConfig {
  static const String merchantId = '1025140'; // Tu merchant ID
  static const String accountId = '1034315'; // Tu account ID
  static const String apiKey = 'GtyOI4RDWGO7pBbDQsptJqMQ1J'; // Tu API Key
  static const String baseUrl = 'https://sandbox.api.payulatam.com'; // Sandbox
  // static const String baseUrl = 'https://api.payulatam.com'; // Producción

  // URLs de respuesta
  static const String responseUrl =
      'https://developers.payu.com/europe/docs/payment-solutions/cards/digital-wallets/google-pay/';
  static const String confirmationUrl = 'https://pub.dev/packages/webview_flutter';
}

/// Modelo de respuesta de PayU
class PayUResponse {
  final bool success;
  final String? transactionId;
  final String? orderId;
  final String? message;
  final String? checkoutUrl;
  final Map<String, dynamic>? rawData;

  const PayUResponse({
    required this.success,
    this.transactionId,
    this.orderId,
    this.message,
    this.checkoutUrl,
    this.rawData,
  });

  factory PayUResponse.fromJson(Map<String, dynamic> json) {
    return PayUResponse(
      success: json['code'] == 'SUCCESS',
      transactionId: json['result']?['payload']?['id']?.toString(),
      orderId: json['result']?['payload']?['orderId']?.toString(),
      message: json['result']?['payload']?['responseMessage'],
      rawData: json,
    );
  }
}

/// Servicio principal para PayU
class PayUGooglePayService extends ChangeNotifier {
  static final PayUGooglePayService _instance = PayUGooglePayService._internal();
  factory PayUGooglePayService() => _instance;
  PayUGooglePayService._internal();

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

      final checkoutUrl = await _generateCheckoutUrl(
        planType: planType,
        amount: amount,
        userEmail: userEmail,
        userName: userName,
        phoneNumber: phoneNumber,
      );

      return PayUResponse(
        success: true,
        message: 'Checkout URL generado exitosamente',
        checkoutUrl: checkoutUrl,
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

  /// Generar URL de checkout para PayU
  Future<String> _generateCheckoutUrl({
    required SubscriptionPlanType planType,
    required double amount,
    required String userEmail,
    required String userName,
    String? phoneNumber,
  }) async {
    final referenceCode =
        'SUB_${planType.id.toUpperCase()}_${DateTime.now().millisecondsSinceEpoch}';
    final signature = _generateSignature(referenceCode, amount);
    // 🔍 DEBUG: Imprimir parámetros
    debugPrint('=== DEBUG PAYU ===');
    debugPrint('merchantId: ${PayUConfig.merchantId}');
    debugPrint('accountId: ${PayUConfig.accountId}');
    debugPrint('referenceCode: $referenceCode');
    debugPrint('amount: ${amount.toStringAsFixed(1)}');
    debugPrint('signature: $signature');
    debugPrint('==================');
    final params = {
      'merchantId': PayUConfig.merchantId,
      'accountId': PayUConfig.accountId,
      'description': 'Suscripción ${planType.displayName} - Recetas Peruanas',
      'referenceCode': referenceCode,
      'amount': amount.toStringAsFixed(1),
      'currency': 'PEN',
      'signature': signature,
      'test': '1', // 0 para producción
      'buyerEmail': userEmail,
      'buyerFullName': userName,
      'responseUrl': PayUConfig.responseUrl,
      'confirmationUrl': PayUConfig.confirmationUrl,
      'lng': 'es',
      // Habilitar Google Pay
      'paymentMethods': 'GOOGLE_PAY,VISA,MASTERCARD',
      'extra1': planType.id, // Para identificar el plan en la respuesta
    };

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return 'https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu/?$queryString';
  }

  /// Generar firma MD5 para PayU
  String _generateSignature(String referenceCode, double amount) {
    final cleanAmount = amount.toStringAsFixed(1);
    final signatureString =
        '${PayUConfig.apiKey}~${PayUConfig.merchantId}~$referenceCode~$cleanAmount~PEN';

    final bytes = utf8.encode(signatureString);
    final digest = md5.convert(bytes);

    return digest.toString();
  }

  /// Procesar respuesta de PayU (llamar cuando regrese del checkout)
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
        'language': 'es',
        'command': 'ORDER_DETAIL',
        'merchant': {'apiKey': PayUConfig.apiKey, 'apiLogin': PayUConfig.merchantId},
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
}

/// Extension para obtener precios con formato PayU
extension PayUPricing on SubscriptionPlanType {
  String get payuFormattedPrice => basePrice.toStringAsFixed(1);
  String get payuDescription => 'Suscripción $displayName - Recetas Peruanas';
}
