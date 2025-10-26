import 'package:dio/dio.dart';
import 'package:lottery_app/global/model/agent_info_type.dart';
import 'package:lottery_app/global/model/common_response_type.dart';
import 'package:lottery_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

part 'agent_info_service.g.dart';

@RestApi()
abstract class AgentInfoService {
  factory AgentInfoService(Dio dio, {String baseUrl}) = _AgentInfoService;

  /// 获取代理商信息
  @GET('/info')
  Future<AgentInfoResponse> getAgentInfo();

  /// 更新代理商信息
  @PATCH('/info')
  Future<CommonBoolResponse> updateAgentInfo(@Body() UpdateAgentInfoRequest request);
}

/// 获取AgentInfoService实例，确保网络管理器已初始化
AgentInfoService get agentInfoService {
  if (netManager.clientDio == null) {
    throw Exception('网络管理器未初始化，请稍后重试');
  }
  return AgentInfoService(netManager.clientDio!);
}
