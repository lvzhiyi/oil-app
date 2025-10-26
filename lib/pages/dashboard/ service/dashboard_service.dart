import 'package:dio/dio.dart';
import 'package:lottery_app/net/net_manager.dart';
import 'package:lottery_app/pages/dashboard/model/dashboard_type.dart';
import 'package:retrofit/retrofit.dart';

part 'dashboard_service.g.dart';

/// 赠送彩票服务API
@RestApi()
abstract class DashboardService {
  factory DashboardService(Dio dio, {String baseUrl}) = _DashboardService;

  /// 批量生成静态二维码
  @GET('/dashboards/gift')
  Future<DashboardDataResponse> getDashboardData();

  /// 获取已经生成的二维码
  @GET('/dashboards/trends')
  Future<DashboardTrendsResponse> getDashboardTrends(
    @Query('startTime') String startTime,
    @Query('endTime') String endTime,
  );
}

/// 获取GiftLotteryService实例，确保网络管理器已初始化
DashboardService get dashboardService {
  return DashboardService(netManager.clientDio!);
}
