import 'package:dio/dio.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:oil_business_app/pages/pay_order_detail/model/payment_proof_request.dart';
import 'package:oil_business_app/pages/pay_order_list/model/orders_data.dart';
import 'package:retrofit/retrofit.dart';

part 'pay_order_service.g.dart';

/// 第三方支付服务API
@RestApi()
abstract class PayOrderService {
  factory PayOrderService(Dio dio, {String baseUrl}) = _PayOrderService;

  /// 获取订单详情
  @GET('/oil-orders/{id}')
  Future<OrderModel> getOrderDetail(
    @Path('id') String id,
  );

  /// 保存支付凭证
  @POST('/oil-orders/{id}/payment-proof')
  Future<void> savePaymentProof(
    @Path('id') String id,
    @Body() PaymentProofRequest request,
  );
}

/// 获取OrderDetailService实例
PayOrderService get payOrderService {
  if (netManager.clientDio == null) {
    throw Exception('网络管理器未初始化，请稍后重试');
  }
  return PayOrderService(netManager.clientDio!);
}

