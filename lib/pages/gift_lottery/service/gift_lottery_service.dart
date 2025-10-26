import 'package:dio/dio.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

part 'gift_lottery_service.g.dart';

/// 赠送彩票服务API
@RestApi()
abstract class GiftLotteryService {
  factory GiftLotteryService(Dio dio, {String baseUrl}) = _GiftLotteryService;

  /// 获取账户信息
  @GET('/gift-lottery/account')
  Future<AccountInfo> getAccountInfo();
}

/// 获取GiftLotteryService实例，确保网络管理器已初始化
GiftLotteryService get giftLotteryService {
  return GiftLotteryService(netManager.clientDio!);
}

/// 账户信息
class AccountInfo {
  final String currentBalance;
  final int availablePackageCount;
  final double lotteryPrice;

  const AccountInfo({
    required this.currentBalance,
    required this.availablePackageCount,
    this.lotteryPrice = 2.0,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      currentBalance: json['currentBalance'] as String,
      availablePackageCount: json['availablePackageCount'] as int,
      lotteryPrice: (json['lotteryPrice'] as num?)?.toDouble() ?? 2.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentBalance': currentBalance,
      'availablePackageCount': availablePackageCount,
      'lotteryPrice': lotteryPrice,
    };
  }
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
