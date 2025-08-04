// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payu_checkout_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayuCheckoutResponseModel _$PayuCheckoutResponseModelFromJson(
  Map<String, dynamic> json,
) => PayuCheckoutResponseModel(
  merchantId: json['merchant_id'] as String?,
  merchantName: json['merchant_name'] as String?,
  merchantAddress: json['merchant_address'] as String?,
  telephone: json['telephone'] as String?,
  merchantUrl: json['merchant_url'] as String?,
  transactionState: json['transaction_state'] as String?,
  lapTransactionState: json['lap_transaction_state'] as String?,
  message: json['message'] as String?,
  referenceCode: json['reference_code'] as String?,
  referencePol: json['reference_pol'] as String?,
  transactionId: json['transaction_id'] as String?,
  description: json['description'] as String?,
  trazabilityCode: json['trazability_code'] as String?,
  cus: json['cus'] as String?,
  orderLanguage: json['order_language'] as String?,
  extra1: json['extra1'] as String?,
  extra2: json['extra2'] as String?,
  extra3: json['extra3'] as String?,
  polTransactionState: json['pol_transaction_state'] as String?,
  signature: json['signature'] as String?,
  polResponseCode: json['pol_response_code'] as String?,
  lapResponseCode: json['lap_response_code'] as String?,
  risk: json['risk'] as String?,
  polPaymentMethod: json['pol_payment_method'] as String?,
  lapPaymentMethod: json['lap_payment_method'] as String?,
  polPaymentMethodType: json['pol_payment_method_type'] as String?,
  lapPaymentMethodType: json['lap_payment_method_type'] as String?,
  installmentsNumber: json['installments_number'] as String?,
  txValue: json['TX_VALUE'] as String?,
  txTax: json['TX_TAX'] as String?,
  currency: json['currency'] as String?,
  lng: json['lng'] as String?,
  pseCycle: json['pse_cycle'] as String?,
  buyerEmail: json['buyer_email'] as String?,
  pseBank: json['pse_bank'] as String?,
  pseReference1: json['pse_reference1'] as String?,
  pseReference2: json['pse_reference2'] as String?,
  pseReference3: json['pse_reference3'] as String?,
  authorizationCode: json['authorization_code'] as String?,
  khipuBank: json['khipu_bank'] as String?,
  txAdministrativeFee: json['TX_ADMINISTRATIVE_FEE'] as String?,
  txTaxAdministrativeFee: json['TX_TAX_ADMINISTRATIVE_FEE'] as String?,
  txTaxAdministrativeFeeReturnBase:
      json['TX_TAX_ADMINISTRATIVE_FEE_RETURN_BASE'] as String?,
  processingDate: json['processing_date'] as String?,
);

Map<String, dynamic> _$PayuCheckoutResponseModelToJson(
  PayuCheckoutResponseModel instance,
) => <String, dynamic>{
  if (instance.merchantId case final value?) 'merchant_id': value,
  if (instance.merchantName case final value?) 'merchant_name': value,
  if (instance.merchantAddress case final value?) 'merchant_address': value,
  if (instance.telephone case final value?) 'telephone': value,
  if (instance.merchantUrl case final value?) 'merchant_url': value,
  if (instance.transactionState case final value?) 'transaction_state': value,
  if (instance.lapTransactionState case final value?)
    'lap_transaction_state': value,
  if (instance.message case final value?) 'message': value,
  if (instance.referenceCode case final value?) 'reference_code': value,
  if (instance.referencePol case final value?) 'reference_pol': value,
  if (instance.transactionId case final value?) 'transaction_id': value,
  if (instance.description case final value?) 'description': value,
  if (instance.trazabilityCode case final value?) 'trazability_code': value,
  if (instance.cus case final value?) 'cus': value,
  if (instance.orderLanguage case final value?) 'order_language': value,
  if (instance.extra1 case final value?) 'extra1': value,
  if (instance.extra2 case final value?) 'extra2': value,
  if (instance.extra3 case final value?) 'extra3': value,
  if (instance.polTransactionState case final value?)
    'pol_transaction_state': value,
  if (instance.signature case final value?) 'signature': value,
  if (instance.polResponseCode case final value?) 'pol_response_code': value,
  if (instance.lapResponseCode case final value?) 'lap_response_code': value,
  if (instance.risk case final value?) 'risk': value,
  if (instance.polPaymentMethod case final value?) 'pol_payment_method': value,
  if (instance.lapPaymentMethod case final value?) 'lap_payment_method': value,
  if (instance.polPaymentMethodType case final value?)
    'pol_payment_method_type': value,
  if (instance.lapPaymentMethodType case final value?)
    'lap_payment_method_type': value,
  if (instance.installmentsNumber case final value?)
    'installments_number': value,
  if (instance.txValue case final value?) 'TX_VALUE': value,
  if (instance.txTax case final value?) 'TX_TAX': value,
  if (instance.currency case final value?) 'currency': value,
  if (instance.lng case final value?) 'lng': value,
  if (instance.pseCycle case final value?) 'pse_cycle': value,
  if (instance.buyerEmail case final value?) 'buyer_email': value,
  if (instance.pseBank case final value?) 'pse_bank': value,
  if (instance.pseReference1 case final value?) 'pse_reference1': value,
  if (instance.pseReference2 case final value?) 'pse_reference2': value,
  if (instance.pseReference3 case final value?) 'pse_reference3': value,
  if (instance.authorizationCode case final value?) 'authorization_code': value,
  if (instance.khipuBank case final value?) 'khipu_bank': value,
  if (instance.txAdministrativeFee case final value?)
    'TX_ADMINISTRATIVE_FEE': value,
  if (instance.txTaxAdministrativeFee case final value?)
    'TX_TAX_ADMINISTRATIVE_FEE': value,
  if (instance.txTaxAdministrativeFeeReturnBase case final value?)
    'TX_TAX_ADMINISTRATIVE_FEE_RETURN_BASE': value,
  if (instance.processingDate case final value?) 'processing_date': value,
};
