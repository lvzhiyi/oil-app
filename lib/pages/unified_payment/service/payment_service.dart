import 'package:dio/dio.dart';
import 'package:lottery_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

import '../model/payment_type.dart';

part 'payment_service.g.dart';

/// 第三方支付服务API
@RestApi()
abstract class PaymentService {
  factory PaymentService(Dio dio, {String baseUrl}) = _PaymentService;

  /// 创建套餐支付订单
  @POST('/recharges')
  Future<CreatePaymentOrderResponse> createPackagePaymentOrder(
    @Body() CreatePackageOrderRequest request,
  );

  /// 创建余额支付订单
  @POST('/recharges')
  Future<CreatePaymentOrderResponse> createBalancePaymentOrder(
    @Body() CreateBalanceOrderRequest request,
  );

  /// 获取套餐列表
  @GET('/packages')
  Future<GetPackagesResponse> getPackages(
    @Query('lotteryType') int lotteryType,
  );
}

/// 获取PaymentService实例
PaymentService get paymentService {
  if (netManager.clientDio == null) {
    throw Exception('网络管理器未初始化，请稍后重试');
  }
  return PaymentService(netManager.clientDio!);
}
