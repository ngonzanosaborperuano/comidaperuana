// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payu_checkout_params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayuCheckoutParamsModel _$PayuCheckoutParamsModelFromJson(
  Map<String, dynamic> json,
) => PayuCheckoutParamsModel(
  merchantId: json['merchantId'] as String,
  accountId: json['accountId'] as String,
  description: json['description'] as String,
  referenceCode: json['referenceCode'] as String,
  paymentMethods: json['paymentMethods'] as String,
  amount: json['amount'] as String,
  currency: json['currency'] as String,
  signature: json['signature'] as String,
  test: json['test'] as String,
  buyerEmail: json['buyerEmail'] as String,
  buyerFullName: json['buyerFullName'] as String,
  responseUrl: json['responseUrl'] as String,
  confirmationUrl: json['confirmationUrl'] as String,
  lng: json['lng'] as String,
);

Map<String, dynamic> _$PayuCheckoutParamsModelToJson(
  PayuCheckoutParamsModel instance,
) => <String, dynamic>{
  'merchantId': instance.merchantId,
  'accountId': instance.accountId,
  'description': instance.description,
  'referenceCode': instance.referenceCode,
  'paymentMethods': instance.paymentMethods,
  'amount': instance.amount,
  'currency': instance.currency,
  'signature': instance.signature,
  'test': instance.test,
  'buyerEmail': instance.buyerEmail,
  'buyerFullName': instance.buyerFullName,
  'responseUrl': instance.responseUrl,
  'confirmationUrl': instance.confirmationUrl,
  'lng': instance.lng,
};
