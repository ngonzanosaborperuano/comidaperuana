// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payu_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayUResponse _$PayUResponseFromJson(Map<String, dynamic> json) => PayUResponse(
  success: json['success'] as bool,
  transactionId: json['transaction_id'] as String?,
  orderId: json['order_id'] as String?,
  message: json['message'] as String?,
  checkoutUrl: json['checkout_url'] as String?,
  rawData: json['raw_data'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$PayUResponseToJson(PayUResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'transaction_id': ?instance.transactionId,
      'order_id': ?instance.orderId,
      'message': ?instance.message,
      'checkout_url': ?instance.checkoutUrl,
      'raw_data': ?instance.rawData,
    };
