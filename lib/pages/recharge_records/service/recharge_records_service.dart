import 'package:dio/dio.dart';
import 'package:lottery_app/net/net_manager.dart';
import 'package:lottery_app/pages/recharge_records/model/common_type.dart';
import 'package:retrofit/retrofit.dart';

part 'recharge_records_service.g.dart';

@RestApi()
abstract class RechargeRecordsService {
  factory RechargeRecordsService(Dio dio, {String baseUrl}) =
      _RechargeRecordsService;

  /// 获取充值记录
  @GET('/recharges')
  Future<RechargeRecordResponse> getRechargeRecords(
    @Query('type') String? type,
    @Query('orderByType') String? orderByType,
    @Query('orderByName') String? orderByName,
    @Query('current') int? current,
    @Query('pageSize') int? pageSize,
  );
}

/// 获取AgentInfoService实例，确保网络管理器已初始化
RechargeRecordsService get rechargeRecordsService {
  if (netManager.clientDio == null) {
    throw Exception('网络管理器未初始化，请稍后重试');
  }
  return RechargeRecordsService(netManager.clientDio!);
}
