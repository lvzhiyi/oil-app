import 'package:dio/dio.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:retrofit/retrofit.dart';

part 'oil_pickup_service.g.dart';

/// 提油服务API
@RestApi()
abstract class OilPickupService {
  factory OilPickupService(Dio dio, {String baseUrl}) = _OilPickupService;

  /// 获取提油订单列表
  @GET('/inventories/withdraws')
  Future<WithdrawOrderListResponse> getWithdrawOrderList({
    @Query('status') String? status,
    @Query('page') required int page,
    @Query('pageSize') required int pageSize,
  });

  /// 提交提油申请
  @POST('/inventories/{orderId}/withdraw')
  Future<WithdrawResponse> submitWithdraw(
    @Path('orderId') int orderId,
    @Body() WithdrawRequest request,
  );

  /// 查询用户可用库存油
  @GET('/inventories')
  Future<InventoryListResponse> getInventories({
    @Query('page') required int page,
    @Query('pageSize') required int pageSize,
  });

  /// 取消提油申请
  @POST('/inventories/withdraws/{withdrawId}/cancel')
  Future<void> cancelWithdraw(
    @Path('withdrawId') int withdrawId,
  );
}

OilPickupService get oilPickupService =>
    OilPickupService(netManager.clientDio!);
