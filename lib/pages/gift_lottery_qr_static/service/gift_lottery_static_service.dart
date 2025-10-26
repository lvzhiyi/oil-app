import 'package:dio/dio.dart';
import 'package:lottery_app/net/net_manager.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/model/common_type.dart';
import 'package:retrofit/retrofit.dart';

part 'gift_lottery_static_service.g.dart';

/// 赠送彩票服务API
@RestApi()
abstract class GiftLotteryStaticService {
  factory GiftLotteryStaticService(Dio dio, {String baseUrl}) =
      _GiftLotteryStaticService;

  /// 批量生成静态二维码
  @POST('/lottery-temp-coupons/static-code')
  Future<void> generateBatchQr(@Body() BatchQrCodeRequest request);

  /// 获取已经生成的二维码
  @GET('/lottery-temp-coupons')
  Future<GetStaticQrCodesResponse> getStaticQrCodes(
    @Query('orderByType') String orderByType,
    @Query('orderByName') String orderByName,
    @Query('current') String current,
    @Query('pageSize') String pageSize,
    @Query('status') String? status,
    @Query('type') String? type,
  );
}

/// 获取GiftLotteryService实例，确保网络管理器已初始化
GiftLotteryStaticService get giftLotteryStaticService {
  return GiftLotteryStaticService(netManager.clientDio!);
}
