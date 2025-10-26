import 'package:dio/dio.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

part 'gift_lottery_dynamic_service.g.dart';

/// 赠送彩票服务API
@RestApi()
abstract class GiftLotteryDynamicService {
  factory GiftLotteryDynamicService(Dio dio, {String baseUrl}) =
      _GiftLotteryDynamicService;

  /// 生成动态二维码
  @POST('/lottery-temp-coupons/dynamic-code')
  Future<DynamicQrResponse> generateDynamicQr(@Body() DynamicQrRequest request);
}

/// 获取GiftLotteryService实例，确保网络管理器已初始化
GiftLotteryDynamicService get giftLotteryDynamicService {
  return GiftLotteryDynamicService(netManager.clientDio!);
}

/// 动态二维码生成请求
class DynamicQrRequest {
  final LotteryType lotteryType;

  const DynamicQrRequest({
    required this.lotteryType,
  });

  factory DynamicQrRequest.fromJson(Map<String, dynamic> json) {
    return DynamicQrRequest(
      lotteryType: LotteryType.values.firstWhere(
        (type) => type.code == json['lotteryType'],
        orElse: () => LotteryType.doubleColorBall,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lotteryType': lotteryType.value,
    };
  }
}

/// 代理商信息API响应
class DynamicQrResponse {
  final int? code;
  final String? message;
  final String? data;

  DynamicQrResponse({this.code, this.message, this.data});

  factory DynamicQrResponse.fromJson(Map<String, dynamic> json) {
    return DynamicQrResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] as String?,
    );
  }
}
