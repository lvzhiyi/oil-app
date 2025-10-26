import 'package:lottery_app/pages/employee_management/model/common_type.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';

class EmployeeManagementState {
  final PageStatus pageStatus;

  /// 员工列表
  final List<EmployeeInfo> employees;

  /// 错误信息
  final String? errorMessage;

  /// 搜索关键词
  final String searchKeyword;

  /// 员工名称筛选
  final String usernameFilter;

  /// 手机号筛选
  final String phoneFilter;

  /// 排序字段
  final String orderByName;

  /// 排序方向（ASC/DESC）
  final String orderByType;

  const EmployeeManagementState({
    this.pageStatus = PageStatus.loading,
    this.employees = const [],
    this.errorMessage,
    this.searchKeyword = '',
    this.usernameFilter = '',
    this.phoneFilter = '',
    this.orderByName = 'createTime',
    this.orderByType = 'DESC',
  });

  EmployeeManagementState copyWith({
    PageStatus? pageStatus,
    List<EmployeeInfo>? employees,
    String? errorMessage,
    String? searchKeyword,
    String? usernameFilter,
    String? phoneFilter,
    String? orderByName,
    String? orderByType,
  }) {
    return EmployeeManagementState(
      pageStatus: pageStatus ?? this.pageStatus,
      employees: employees ?? this.employees,
      errorMessage: errorMessage ?? this.errorMessage,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      usernameFilter: usernameFilter ?? this.usernameFilter,
      phoneFilter: phoneFilter ?? this.phoneFilter,
      orderByName: orderByName ?? this.orderByName,
      orderByType: orderByType ?? this.orderByType,
    );
  }
}
