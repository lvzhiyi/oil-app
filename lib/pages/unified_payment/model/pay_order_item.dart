import 'package:json_annotation/json_annotation.dart';
part 'pay_order_item.g.dart';

@JsonSerializable()
class PayOrderItem {
  @JsonKey(name: 'uuid')
  String? uuid;
  @JsonKey(name: 'tenantUuid')
  String? tenantUuid;
  @JsonKey(name: 'type')
  String? type;
  @JsonKey(name: 'quota')
  String? quota;
  @JsonKey(name: 'lotteryType')
  String? lotteryType;
  @JsonKey(name: 'payAmount')
  String? payAmount;
  @JsonKey(name: 'remark')
  String? remark;
  @JsonKey(name: 'paymentMethod')
  String? paymentMethod;
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'createTime')
  String? createTime;

  PayOrderItem({
    this.uuid,
    this.tenantUuid,
    this.type,
    this.quota,
    this.lotteryType,
    this.payAmount,
    this.remark,
    this.paymentMethod,
    this.status,
    this.createTime,
  });

  factory PayOrderItem.fromJson(Map<String, dynamic> json) =>
      _$PayOrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$PayOrderItemToJson(this);

  PayOrderItem copyWith({
    String? uuid,
    String? tenantUuid,
    String? type,
    String? quota,
    String? lotteryType,
    String? payAmount,
    String? remark,
    String? paymentMethod,
    String? status,
    String? createTime,
  }) {
    return PayOrderItem(
      uuid: uuid ?? this.uuid,
      tenantUuid: tenantUuid ?? this.tenantUuid,
      type: type ?? this.type,
      quota: quota ?? this.quota,
      lotteryType: lotteryType ?? this.lotteryType,
      payAmount: payAmount ?? this.payAmount,
      remark: remark ?? this.remark,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createTime: createTime ?? this.createTime,
    );
  }
}
