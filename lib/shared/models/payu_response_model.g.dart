// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payu_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayUResponse _$PayUResponseFromJson(Map<String, dynamic> json) => PayUResponse(
  success: json['success'] as bool,
  transactionId: json['transactionId'] as String?,
  orderId: json['orderId'] as String?,
  message: json['message'] as String?,
  checkoutUrl: json['checkoutUrl'] as String?,
  rawData: json['rawData'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$PayUResponseToJson(PayUResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'transactionId': instance.transactionId,
      'orderId': instance.orderId,
      'message': instance.message,
      'checkoutUrl': instance.checkoutUrl,
      'rawData': instance.rawData,
    };
