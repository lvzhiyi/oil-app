import 'package:json_annotation/json_annotation.dart';

part 'payment_proof_request.g.dart';

/// 保存支付凭证请求
@JsonSerializable()
class PaymentProofRequest {
  /// 凭证URL列表
  final List<String> proof;

  PaymentProofRequest({
    required this.proof,
  });

  factory PaymentProofRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentProofRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentProofRequestToJson(this);
}

