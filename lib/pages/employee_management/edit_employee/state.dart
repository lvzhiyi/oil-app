import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/employee_management/model/common_type.dart';
import 'package:lottery_app/pages/employee_management/model/employee_type.dart';

/// 编辑员工页面状态
class EditEmployeeState {
  /// 是否正在加载
  final bool isLoading;

  /// 是否是编辑模式（否则为新建模式）
  final bool isEditMode;

  /// 员工ID（编辑模式下有效）
  final String? employeeId;

  /// 员工详情数据
  final EmployeeDetailData? employeeDetail;

  /// 用户名
  final String username;

  /// 手机号
  final String phone;

  /// 账号
  final String account;

  /// 密码
  final String password;

  /// 旧密码（修改密码时需要）
  final String oldPassword;

  /// 角色
  final List<EmployeeRole> roles;

  /// 彩票赠送权限配置
  final List<LotteryGiftConfig> codeConf;

  /// 是否有错误
  final bool hasError;

  /// 错误信息
  final String? errorMessage;

  const EditEmployeeState({
    this.isLoading = false,
    this.isEditMode = false,
    this.employeeId,
    this.employeeDetail,
    this.username = '',
    this.phone = '',
    this.account = '',
    this.password = '',
    this.oldPassword = '',
    this.roles = const [EmployeeRole.employee],
    this.codeConf = const [],
    this.hasError = false,
    this.errorMessage,
  });

  EditEmployeeState copyWith({
    bool? isLoading,
    bool? isEditMode,
    String? employeeId,
    EmployeeDetailData? employeeDetail,
    String? username,
    String? phone,
    String? account,
    String? password,
    String? oldPassword,
    List<EmployeeRole>? roles,
    List<LotteryGiftConfig>? codeConf,
    bool? hasError,
    String? errorMessage,
  }) {
    return EditEmployeeState(
      isLoading: isLoading ?? this.isLoading,
      isEditMode: isEditMode ?? this.isEditMode,
      employeeId: employeeId ?? this.employeeId,
      employeeDetail: employeeDetail ?? this.employeeDetail,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      account: account ?? this.account,
      password: password ?? this.password,
      oldPassword: oldPassword ?? this.oldPassword,
      roles: roles ?? this.roles,
      codeConf: codeConf ?? this.codeConf,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasStatic => codeConf.any((config) => config.type == LotteryTempCouponTypeEnum.static);
  bool get hasDynamic => codeConf.any((config) => config.type == LotteryTempCouponTypeEnum.dynamic);

  bool get canAddMore => (!hasStatic || !hasDynamic);

  List<LotteryTempCouponTypeEnum> get availableTypes {
    final availableTypes = <LotteryTempCouponTypeEnum>[];
    if (!hasStatic) availableTypes.add(LotteryTempCouponTypeEnum.static);
    if (!hasDynamic) availableTypes.add(LotteryTempCouponTypeEnum.dynamic);
    return availableTypes;
  }
}
