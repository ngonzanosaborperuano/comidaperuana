import 'package:equatable/equatable.dart' show Equatable;
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'payu_checkout_params_model.g.dart';

@immutable
@JsonSerializable()
class PayuCheckoutParamsModel extends Equatable {
  @JsonKey(name: 'merchantId')
  final String merchantId;

  @JsonKey(name: 'accountId')
  final String accountId;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'referenceCode')
  final String referenceCode;

  @JsonKey(name: 'paymentMethods')
  final String paymentMethods;

  @JsonKey(name: 'amount')
  final String amount;

  @JsonKey(name: 'currency')
  final String currency;

  @JsonKey(name: 'signature')
  final String signature;

  @JsonKey(name: 'test')
  final String test;

  @JsonKey(name: 'buyerEmail')
  final String buyerEmail;

  @JsonKey(name: 'buyerFullName')
  final String buyerFullName;

  @JsonKey(name: 'responseUrl')
  final String responseUrl;

  @JsonKey(name: 'confirmationUrl')
  final String confirmationUrl;

  @JsonKey(name: 'lng')
  final String lng;

  const PayuCheckoutParamsModel({
    required this.merchantId,
    required this.accountId,
    required this.description,
    required this.referenceCode,
    required this.paymentMethods,
    required this.amount,
    required this.currency,
    required this.signature,
    required this.test,
    required this.buyerEmail,
    required this.buyerFullName,
    required this.responseUrl,
    required this.confirmationUrl,
    required this.lng,
  });

  static const PayuCheckoutParamsModel empty = PayuCheckoutParamsModel(
    merchantId: '',
    accountId: '',
    description: '',
    referenceCode: '',
    paymentMethods: '',
    amount: '',
    currency: '',
    signature: '',
    test: '',
    buyerEmail: '',
    buyerFullName: '',
    responseUrl: '',
    confirmationUrl: '',
    lng: '',
  );

  factory PayuCheckoutParamsModel.fromJson(Map<String, dynamic> json) =>
      _$PayuCheckoutParamsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayuCheckoutParamsModelToJson(this);

  /// Método de conveniencia para crear desde los parámetros del servicio
  factory PayuCheckoutParamsModel.fromServiceParams({
    required String merchantId,
    required String accountId,
    required String description,
    required String referenceCode,
    required String paymentMethods,
    required String amount,
    required String currency,
    required String signature,
    required bool test,
    required String buyerEmail,
    required String buyerName,
    required String responseUrl,
    required String confirmationUrl,
    String lng = 'es',
  }) {
    return PayuCheckoutParamsModel(
      merchantId: merchantId,
      accountId: accountId,
      description: description,
      referenceCode: referenceCode,
      paymentMethods: paymentMethods,
      amount: amount,
      currency: currency,
      signature: signature,
      test: test ? '1' : '0',
      buyerEmail: buyerEmail,
      buyerFullName: buyerName,
      responseUrl: responseUrl,
      confirmationUrl: confirmationUrl,
      lng: lng,
    );
  }

  Map<String, String> toServiceMap() {
    return {
      'merchantId': merchantId,
      'accountId': accountId,
      'description': description,
      'referenceCode': referenceCode,
      'paymentMethods': paymentMethods,
      'amount': amount,
      'currency': currency,
      'signature': signature,
      'test': test,
      'buyerEmail': buyerEmail,
      'buyerFullName': buyerFullName,
      'responseUrl': responseUrl,
      'confirmationUrl': confirmationUrl,
      'lng': lng,
    };
  }

  @override
  List<Object?> get props => [
    merchantId,
    accountId,
    description,
    referenceCode,
    paymentMethods,
    amount,
    currency,
    signature,
    test,
    buyerEmail,
    buyerFullName,
    responseUrl,
    confirmationUrl,
    lng,
  ];
}
