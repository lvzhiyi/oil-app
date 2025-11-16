import 'package:dio/dio.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

import '../model/pay_order_type.dart';

part 'pay_order_service.g.dart';

/// 第三方支付服务API
@RestApi()
abstract class PayOrderService {
  factory PayOrderService(Dio dio, {String baseUrl}) = _PayOrderService;

  /// 取消订单
  @PATCH('/recharges/{uuid}')
  Future<OrderDetailResponse> cancelRecharge(
    @Path('uuid') String uuid,
    @Body() CancelRechargeRequest request,
  );

  /// 更新订单的支付凭证
  @PATCH('/recharges/{uuid}')
  Future<OrderDetailResponse> updateOrderVoucher(
    @Path('uuid') String uuid,
    @Body() UpdateOrderVoucherRequest request,
  );

  /// 上传凭证文件
  @POST('/files/upload')
  Future<FileUploadResponse> uploadFile(
    @Body() FormData formData,
  );

  /// 获取文件签名URL
  @GET('/files/sign-url')
  Future<FileSignUrlResponse> getFileSignUrl(
    @Query('filePath') String filePath,
  );

  /// 获取订单详情
  @GET('/recharges/{uuid}')
  Future<OrderDetailResponse> getOrderDetail(
    @Path('uuid') String uuid,
  );
}

/// 获取OrderDetailService实例
PayOrderService get payOrderService {
  if (netManager.clientDio == null) {
    throw Exception('网络管理器未初始化，请稍后重试');
  }
  return PayOrderService(netManager.clientDio!);
}
