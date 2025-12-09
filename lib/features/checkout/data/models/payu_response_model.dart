import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payu_response_model.g.dart';

@JsonSerializable()
class PayUResponse extends Equatable {
  const PayUResponse({
    required this.success,
    this.transactionId,
    this.orderId,
    this.message,
    this.checkoutUrl,
    this.rawData,
  });

  final bool success;
  final String? transactionId;
  final String? orderId;
  final String? message;
  final String? checkoutUrl;
  final Map<String, dynamic>? rawData;

  factory PayUResponse.fromJson(Map<String, dynamic> json) => _$PayUResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PayUResponseToJson(this);

  static const PayUResponse empty = PayUResponse(success: false);

  @override
  List<Object?> get props => [success, transactionId, orderId, message, checkoutUrl, rawData];
}
