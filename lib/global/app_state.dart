import 'package:lottery_app/global/model/agent_info_type.dart';
import 'package:lottery_app/pages/employee_management/model/employee_type.dart';

class AppState {
  /// 当前登录员工信息
  CurrentEmployeeData? currentEmployee;

  /// 代理商信息
  AgentInfo? agentInfo;

  AppState({this.currentEmployee, this.agentInfo});

  AppState copyWith({
    CurrentEmployeeData? currentEmployee,
    AgentInfo? agentInfo,
  }) {
    return AppState(
      currentEmployee: currentEmployee ?? this.currentEmployee,
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
