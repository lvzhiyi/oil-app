import 'package:lottery_app/global/enum/common.dart';

/// 彩票套餐类型
class LotteryPackage {
  final String uuid;
  final String name;
  final int ticketCount;
  final double price;
  final double unitPrice;
  final String? description;
  final bool? isPopular;

  const LotteryPackage({
    required this.uuid,
    required this.name,
    required this.ticketCount,
    required this.price,
    required this.unitPrice,
    this.description,
    this.isPopular,
  });

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'ticketCount': ticketCount,
        'price': price,
        'unitPrice': unitPrice,
        'description': description,
        'isPopular': isPopular,
      };

  factory LotteryPackage.fromJson(Map<String, dynamic> json) => LotteryPackage(
        uuid: json['uuid'],
        name: json['name'],
        ticketCount: json['ticketCount'],
        price: json['price'],
        unitPrice: json['unitPrice'],
        description: json['description'],
        isPopular: json['isPopular'],
      );
}

/// 充值订单
class RechargeOrder {
  final String id;
  final PaymentType type;
  final double amount;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final DateTime createTime;
  final String? packageId;
  final String? remark;
  final String? paymentId;
  final DateTime? completeTime;
  final String? paymentUrl;

  const RechargeOrder({
    required this.id,
    required this.type,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.createTime,
    this.packageId,
    this.remark,
    this.paymentId,
    this.completeTime,
    this.paymentUrl,
  });

  RechargeOrder copyWith({
    String? id,
    PaymentType? type,
    double? amount,
    PaymentMethod? paymentMethod,
    OrderStatus? status,
    DateTime? createTime,
    String? packageId,
    String? remark,
    String? paymentId,
    DateTime? completeTime,
    String? paymentUrl,
  }) {
    return RechargeOrder(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createTime: createTime ?? this.createTime,
      packageId: packageId ?? this.packageId,
      remark: remark ?? this.remark,
      paymentId: paymentId ?? this.paymentId,
      completeTime: completeTime ?? this.completeTime,
      paymentUrl: paymentUrl ?? this.paymentUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.value,
        'amount': amount,
        'paymentMethod': paymentMethod.value,
        'status': status.value,
        'createTime': createTime.toIso8601String(),
        'packageId': packageId,
        'remark': remark,
        'paymentId': paymentId,
        'completeTime': completeTime?.toIso8601String(),
        'paymentUrl': paymentUrl,
      };

  factory RechargeOrder.fromJson(Map<String, dynamic> json) => RechargeOrder(
        id: json['id'],
        type: PaymentType.values.firstWhere((e) => e.value == json['type']),
        amount: json['amount'],
        paymentMethod: PaymentMethod.values
            .firstWhere((e) => e.value == json['paymentMethod']),
        status: OrderStatus.values.firstWhere((e) => e.value == json['status']),
        createTime: DateTime.parse(json['createTime']),
        packageId: json['packageId'],
        remark: json['remark'],
        paymentId: json['paymentId'],
        completeTime: json['completeTime'] != null
            ? DateTime.parse(json['completeTime'])
            : null,
        paymentUrl: json['paymentUrl'],
      );
}
