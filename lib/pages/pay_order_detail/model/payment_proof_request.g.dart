// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_proof_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProofRequest _$PaymentProofRequestFromJson(Map<String, dynamic> json) =>
    PaymentProofRequest(
      proof: (json['proof'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PaymentProofRequestToJson(
        PaymentProofRequest instance) =>
    <String, dynamic>{
      'proof': instance.proof,
    };
