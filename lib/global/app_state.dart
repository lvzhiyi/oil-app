import 'package:oil_business_app/global/model/agent_info_type.dart';

class AppState {
  /// 代理商信息
  AgentInfo? agentInfo;

  AppState({this.agentInfo});

  AppState copyWith({
    AgentInfo? agentInfo,
  }) {
    return AppState(
      agentInfo: agentInfo ?? this.agentInfo,
    );
  }

  /// 余额
  double get balance => double.parse(agentInfo?.balance ?? '0.0');

  /// 是否存在彩票套餐
  bool get hasLottery =>
      agentInfo?.packageBalance.entries.any((e) => e.value > 0) ?? false;

  double get miniDepositAmount =>
      double.parse(agentInfo?.miniDepositAmount ?? '100');
}
