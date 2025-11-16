/// 创建买油订单请求
class OilOrderRequest {
  /// 油库ID
  final int depotId;

  /// 油品类型
  final String fuelType;

  /// 购买吨数
  final String purchaseTon;

  /// 备注
  final String? remark;

  OilOrderRequest({
    required this.depotId,
    required this.fuelType,
    required this.purchaseTon,
    this.remark,
  });

  Map<String, dynamic> toJson() => {
        'depotId': depotId,
        'fuelType': fuelType,
        'purchaseTon': purchaseTon,
        if (remark != null && remark!.isNotEmpty) 'remark': remark,
      };
}

