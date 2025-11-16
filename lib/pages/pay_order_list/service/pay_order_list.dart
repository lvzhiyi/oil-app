import 'package:dio/dio.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:oil_business_app/pages/pay_order_list/model/orders_data.dart';
import 'package:retrofit/retrofit.dart';

part 'pay_order_list.g.dart';

/// 第三方支付服务API
@RestApi()
abstract class PayOrderListService {
  factory PayOrderListService(Dio dio, {String baseUrl}) = _PayOrderListService;

  /// 获取买油订单列表
  @GET('/oil-orders')
  Future<OrderListResponse> getOrderList({
    @Query('page') required int page,
    @Query('pageSize') required int pageSize,
  });

  /// 取消订单
  @POST('/oil-orders/{id}/cancel')
  Future<void> cancelOrder(
    @Path('id') String id,
    @Field('reason') String reason,
  );
}

PayOrderListService get payOrderListService =>
    PayOrderListService(netManager.clientDio!);
