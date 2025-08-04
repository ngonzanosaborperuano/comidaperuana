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
      if (instance.transactionId case final value?) 'transaction_id': value,
      if (instance.orderId case final value?) 'order_id': value,
      if (instance.message case final value?) 'message': value,
      if (instance.checkoutUrl case final value?) 'checkout_url': value,
      if (instance.rawData case final value?) 'raw_data': value,
    };
