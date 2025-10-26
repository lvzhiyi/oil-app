import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/net/code.dart';
import 'package:lottery_app/pages/employee_management/edit_employee/state.dart';
import 'package:lottery_app/pages/employee_management/model/common_type.dart';
import 'package:lottery_app/pages/employee_management/service/employee_service.dart';
import 'package:lottery_app/utils/form_validators.dart';
import 'package:lottery_app/utils/log.dart';

class EditEmployeeController extends Cubit<EditEmployeeState> {
  EditEmployeeController({String? employeeId})
      : super(EditEmployeeState(
          isEditMode: employeeId != null,
          employeeId: employeeId,
        )) {
    initState();
  }

  /// 初始化状态
  Future<void> initState() async {
    if (state.isEditMode && state.employeeId != null) {
      await loadEmployeeDetail();
    }
  }

  /// 加载员工详情
  Future<void> loadEmployeeDetail() async {
    if (state.employeeId == null) return;

    emit(state.copyWith(isLoading: true));

    try {
      final response =
          await employeeService.getEmployeeDetail(state.employeeId!);

      if (response.code == HttpCode.success && response.data != null) {
        // 服务端返回的角色需与本地规则对齐：去除owner，确保包含employee
        final List<EmployeeRole> serverRoles = response.data!.roles;
        final List<EmployeeRole> normalizedRoles = [
          ...serverRoles.where((r) => r != EmployeeRole.owner),
        ];
        if (!normalizedRoles.contains(EmployeeRole.employee)) {
          normalizedRoles.add(EmployeeRole.employee);
        }

        emit(state.copyWith(
          isLoading: false,
          employeeDetail: response.data,
          username: response.data!.username,
          phone: response.data!.phone,
          account: response.data!.account,
          roles: normalizedRoles,
          codeConf: response.data!.codeConf,
          hasError: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: response.message ?? '获取员工详情失败',
        ));
      }
    } catch (e) {
      l.e('EditEmployeeController', '加载员工详情失败: $e');
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: '加载员工详情失败，请稍后重试',
      ));
    }
  }

  /// 更新用户名
  void updateUsername(String username) {
    emit(state.copyWith(username: username));
  }

  /// 更新手机号
  void updatePhone(String phone) {
    emit(state.copyWith(phone: phone));
  }

  /// 更新账号
  void updateAccount(String account) {
    emit(state.copyWith(account: account));
  }

  /// 更新密码
  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  /// 更新旧密码
  void updateOldPassword(String oldPassword) {
    emit(state.copyWith(oldPassword: oldPassword));
  }

  /// 更新角色
  void updateRoles(List<EmployeeRole> roles) {
    final List<EmployeeRole> normalized = [
      ...roles.where((r) => r != EmployeeRole.owner),
    ];
    if (!normalized.contains(EmployeeRole.employee)) {
      normalized.add(EmployeeRole.employee);
    }
    emit(state.copyWith(roles: normalized));
  }

  /// 更新彩票赠送权限配置
  void updateCodeConf(List<LotteryGiftConfig> codeConf) {
    emit(state.copyWith(codeConf: codeConf));
  }

  /// 添加彩票赠送权限配置项
  void addCodeConfItem({LotteryTempCouponTypeEnum? type}) {
    // 检查是否已经有相同类型的配置
    if (type == LotteryTempCouponTypeEnum.static && state.hasStatic) {
      return; // 如果已存在相同类型，则不添加
    }

    // 检查是否已经有两个配置项
    if (type == LotteryTempCouponTypeEnum.dynamic && state.hasDynamic) {
      return; // 如果已有两个配置项，则不添加
    }

    final newConfig = LotteryGiftConfig(
      type: type ?? LotteryTempCouponTypeEnum.static,
      num: type == LotteryTempCouponTypeEnum.static ? '100' : '10',
      enable: 1,
    );

    // 创建新列表而不是修改原列表
    final updatedList = List<LotteryGiftConfig>.from(state.codeConf);
    updatedList.add(newConfig);

    // 安全地更新状态
    emit(state.copyWith(codeConf: updatedList));
  }

  /// 删除彩票赠送权限配置项
  void removeCodeConfItem(LotteryTempCouponTypeEnum type) {
    final updatedList = List<LotteryGiftConfig>.from(state.codeConf);
    final index = updatedList.indexWhere((config) => config.type == type);
    if (index >= 0 && index < state.codeConf.length) {
      updatedList.removeAt(index);

      // 安全地更新状态
      emit(state.copyWith(codeConf: updatedList));
    }
  }

  /// 更新指定索引的彩票赠送权限配置项
  void updateCodeConfItem(LotteryTempCouponTypeEnum type, int enable) {
    final updatedList = List<LotteryGiftConfig>.from(state.codeConf);
    final index = updatedList.indexWhere((config) => config.type == type);
    if (index >= 0 && index < state.codeConf.length) {
      updatedList[index] = updatedList[index].copyWith(enable: enable);

      // 安全地更新状态
      emit(state.copyWith(codeConf: updatedList));
    }
  }

  void updateCodeConfItemNum(LotteryTempCouponTypeEnum type, String num) {
    final updatedList = List<LotteryGiftConfig>.from(state.codeConf);
    final index = updatedList.indexWhere((config) => config.type == type);
    if (index >= 0 && index < state.codeConf.length) {
      updatedList[index] = updatedList[index].copyWith(num: num);
    }
    emit(state.copyWith(codeConf: updatedList));
  }

  /// 保存员工信息
  Future<bool> saveEmployee() async {
    // 先进行数据校验
    final validationError = _validateEmployeeData();
    if (validationError != null) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: validationError,
      ));
      return false;
    }

    emit(state.copyWith(isLoading: true));

    try {
      if (state.isEditMode) {
        // 编辑模式
        return await _updateEmployee();
      } else {
        // 新建模式
        return await _createEmployee();
      }
    } catch (e) {
      l.e('EditEmployeeController', '保存员工信息失败: $e');
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: '保存员工信息失败，请稍后重试',
      ));
      return false;
    }
  }

  /// 校验员工数据
  String? _validateEmployeeData() {
    // 校验姓名
    final nameError = FormValidators.validateEmployeeName(state.username);
    if (nameError != null) {
      return nameError;
    }

    // 校验手机号
    final phoneError = FormValidators.validatePhone(state.phone);
    if (phoneError != null) {
      return phoneError;
    }

    // 新建模式下校验密码
    if (!state.isEditMode) {
      final passwordError = FormValidators.validatePassword(state.password);
      if (passwordError != null) {
        return passwordError;
      }
    }

    // 校验角色
    final roleError = FormValidators.validateRoles(state.roles);
    if (roleError != null) {
      return roleError;
    }

    return null;
  }

  /// 创建新员工
  Future<bool> _createEmployee() async {
    try {
      final processedCodeConf = state.codeConf.map((config) {
        if (config.type == LotteryTempCouponTypeEnum.dynamic) {
          // 随便传一个数字，后台不会校验
          return config.copyWith(num: '10');
        }
        return config;
      }).toList();

      // 构建请求体
      final Map<String, dynamic> requestBody = {
        'username': state.username,
        'phone': state.phone,
        'password': state.password,
        'roles': state.roles.map((role) => role.name).toList(),
        'codeConf': processedCodeConf.map((config) => config.toJson()).toList(),
      };
      print('requestBody: $requestBody');
      // 调用API
      final response = await employeeService.createEmployee(requestBody);

      if (response.code == HttpCode.success) {
        emit(state.copyWith(isLoading: false, hasError: false));
        return true;
      } else {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: response.message ?? '创建员工失败',
        ));
        return false;
      }
    } catch (e) {
      l.e('EditEmployeeController', '创建员工失败: $e');
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: '创建员工失败，请稍后重试',
      ));
      return false;
    }
  }

  /// 更新员工信息
  Future<bool> _updateEmployee() async {
    if (state.employeeId == null) return false;

    try {
      final processedCodeConf = state.codeConf.map((config) {
        if (config.type == LotteryTempCouponTypeEnum.dynamic) {
          // 随便传一个数字，后台不会校验
          return config.copyWith(num: '10');
        }
        return config;
      }).toList();

      // 构建请求体
      final Map<String, dynamic> requestBody = {
        'username': state.username,
        'phone': state.phone,
        'roles': state.roles.map((role) => role.name).toList(),
        'codeConf': processedCodeConf.map((config) => config.toJson()).toList(),
      };
      print('requestBody: $requestBody');
      // 编辑模式下密码不可修改，不向后端传递任何密码相关字段

      // 调用API
      final response = await employeeService.updateEmployee(state.employeeId!, requestBody);

      if (response.code == HttpCode.success) {
        emit(state.copyWith(isLoading: false, hasError: false));
        return true;
      } else {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: response.message ?? '更新员工信息失败',
        ));
        return false;
      }
    } catch (e) {
      l.e('EditEmployeeController', '更新员工信息失败: $e');
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: '更新员工信息失败，请稍后重试',
      ));
      return false;
    }
  }
}
