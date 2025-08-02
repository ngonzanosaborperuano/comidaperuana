import 'package:equatable/equatable.dart' show Equatable;
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'payu_checkout_response_model.g.dart';

@immutable
@JsonSerializable()
class PayuCheckoutResponseModel extends Equatable {
  final String? merchantId;
  @JsonKey(name: 'merchant_name')
  final String? merchantName;
  @JsonKey(name: 'merchant_address')
  final String? merchantAddress;
  final String? telephone;
  @JsonKey(name: 'merchant_url')
  final String? merchantUrl;
  final String? transactionState;
  final String? lapTransactionState;
  final String? message;
  final String? referenceCode;
  @JsonKey(name: 'reference_pol')
  final String? referencePol;
  final String? transactionId;
  final String? description;
  final String? trazabilityCode;
  final String? cus;
  final String? orderLanguage;
  final String? extra1;
  final String? extra2;
  final String? extra3;
  final String? polTransactionState;
  final String? signature;
  final String? polResponseCode;
  final String? lapResponseCode;
  final String? risk;
  final String? polPaymentMethod;
  final String? lapPaymentMethod;
  final String? polPaymentMethodType;
  final String? lapPaymentMethodType;
  final String? installmentsNumber;
  @JsonKey(name: 'TX_VALUE')
  final String? txValue;
  @JsonKey(name: 'TX_TAX')
  final String? txTax;
  final String? currency;
  final String? lng;
  final String? pseCycle;
  final String? buyerEmail;
  final String? pseBank;
  final String? pseReference1;
  final String? pseReference2;
  final String? pseReference3;
  final String? authorizationCode;
  final String? khipuBank;
  @JsonKey(name: 'TX_ADMINISTRATIVE_FEE')
  final String? txAdministrativeFee;
  @JsonKey(name: 'TX_TAX_ADMINISTRATIVE_FEE')
  final String? txTaxAdministrativeFee;
  @JsonKey(name: 'TX_TAX_ADMINISTRATIVE_FEE_RETURN_BASE')
  final String? txTaxAdministrativeFeeReturnBase;
  final String? processingDate;

  const PayuCheckoutResponseModel({
    this.merchantId,
    this.merchantName,
    this.merchantAddress,
    this.telephone,
    this.merchantUrl,
    this.transactionState,
    this.lapTransactionState,
    this.message,
    this.referenceCode,
    this.referencePol,
    this.transactionId,
    this.description,
    this.trazabilityCode,
    this.cus,
    this.orderLanguage,
    this.extra1,
    this.extra2,
    this.extra3,
    this.polTransactionState,
    this.signature,
    this.polResponseCode,
    this.lapResponseCode,
    this.risk,
    this.polPaymentMethod,
    this.lapPaymentMethod,
    this.polPaymentMethodType,
    this.lapPaymentMethodType,
    this.installmentsNumber,
    this.txValue,
    this.txTax,
    this.currency,
    this.lng,
    this.pseCycle,
    this.buyerEmail,
    this.pseBank,
    this.pseReference1,
    this.pseReference2,
    this.pseReference3,
    this.authorizationCode,
    this.khipuBank,
    this.txAdministrativeFee,
    this.txTaxAdministrativeFee,
    this.txTaxAdministrativeFeeReturnBase,
    this.processingDate,
  });
  static const PayuCheckoutResponseModel empty = PayuCheckoutResponseModel();

  factory PayuCheckoutResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PayuCheckoutResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PayuCheckoutResponseModelToJson(this);

  @override
  List<Object?> get props => [
    merchantId,
    merchantName,
    merchantAddress,
    telephone,
    merchantUrl,
    transactionState,
    lapTransactionState,
    message,
    referenceCode,
    referencePol,
    transactionId,
    description,
    trazabilityCode,
    cus,
    orderLanguage,
    extra1,
    extra2,
    extra3,
    polTransactionState,
    signature,
    polResponseCode,
    lapResponseCode,
    risk,
    polPaymentMethod,
    lapPaymentMethod,
    polPaymentMethodType,
    lapPaymentMethodType,
    installmentsNumber,
    txValue,
    txTax,
    currency,
    lng,
    pseCycle,
    buyerEmail,
    pseBank,
    pseReference1,
    pseReference2,
    pseReference3,
    authorizationCode,
    khipuBank,
    txAdministrativeFee,
    txTaxAdministrativeFee,
    txTaxAdministrativeFeeReturnBase,
    processingDate,
  ];
}
