import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/employee_management/model/common_type.dart';
import 'package:lottery_app/pages/employee_management/service/employee_service.dart';
import 'package:lottery_app/pages/employee_management/state.dart';
import 'package:lottery_app/utils/log.dart';
import 'package:lottery_app/net/code.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';
import 'package:lottery_app/widgets/popup/toast.dart';

import 'model/rest_employee_response_data.dart';

class EmployeeManagementCtrl extends Cubit<EmployeeManagementState> {
  EmployeeManagementCtrl() : super(const EmployeeManagementState()) {
    initState();
  }

  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  int pageNum = 1;
  int total = 0;
  int pageSize = 4;

  initState() async {
    await loadEmployeeList();
  }

  /// 加载员工列表
  Future<List<EmployeeInfo>> loadEmployeeList(
      {bool isRefresh = false, bool loadMore = false}) async {
    refreshController.finishLoad(IndicatorResult.none);
    if (!isRefresh && !loadMore) {
      emit(state.copyWith(pageStatus: PageStatus.loading));
    }
    try {
      // 调用API获取员工列表
      final response = await employeeService.getEmployeeList(
        current: pageNum,
        pageSize: pageSize,
        username: state.usernameFilter.isNotEmpty ? state.usernameFilter : null,
        phone: state.phoneFilter.isNotEmpty ? state.phoneFilter : null,
        orderByType: state.orderByType,
        orderByName: state.orderByName,
      );

      // 转换API响应数据
      List<EmployeeInfo> employees = response.data!.list;
      total = response.data!.total;

      if (employees.isEmpty) {
        emit(state.copyWith(pageStatus: PageStatus.empty));
        return [];
      }

      /// 加载下一页统一在外部处理新的列表
      if (!loadMore) {
        emit(state.copyWith(
          employees: employees,
          pageStatus: PageStatus.success,
        ));
      }
      return employees;
    } catch (e) {
      l.e('EmployeeManagementCtrl', '加载员工列表失败: $e');
      // 无论什么错误（包括401、网络错误等），都保持页面正常显示
      // 只是将员工列表设为空，显示"暂无数据"
      emit(state.copyWith(
        pageStatus: PageStatus.error,
        employees: [], // 清空员工列表，显示暂无数据
        errorMessage: null,
      ));
      return [];
    }
  }

  /// 刷新数据
  Future<void> refreshData() async {
    pageNum = 1;
    await loadEmployeeList(isRefresh: true);
    refreshController.finishRefresh(IndicatorResult.success);
  }

  /// 加载更多
  void onLoading() async {
    if (state.employees.length >= total) {
      refreshController.finishLoad(IndicatorResult.noMore);
      return;
    }
    pageNum++;
    final employeesNewData = await loadEmployeeList(loadMore: true);
    refreshController.finishLoad(IndicatorResult.success);
    emit(state.copyWith(
      employees: [...state.employees, ...employeesNewData],
    ));
  }

  /// 搜索员工
  Future<void> searchEmployees(String keyword) async {
    pageNum = 1;
    // 兼容旧的搜索行为：输入即同时作为姓名和手机号筛选
    emit(state.copyWith(
      searchKeyword: keyword,
      usernameFilter: keyword,
    ));
    await loadEmployeeList();
  }

  /// 更新筛选：员工名称
  void updateUsernameFilter(String username) {
    emit(state.copyWith(usernameFilter: username));
  }

  /// 更新筛选：手机号
  void updatePhoneFilter(String phone) {
    emit(state.copyWith(phoneFilter: phone));
  }

  /// 更新排序字段
  void updateOrderByName(String name) {
    emit(state.copyWith(orderByName: name));
  }

  /// 更新排序方向（ASC/DESC）
  void updateOrderByType(String type) {
    emit(state.copyWith(orderByType: type));
  }

  /// 应用当前筛选条件
  Future<void> applyFilters() async {
    pageNum = 1;
    await loadEmployeeList();
  }

  /// 清空筛选条件
  Future<void> clearFilters() async {
    emit(state.copyWith(
      searchKeyword: '',
      usernameFilter: '',
      phoneFilter: '',
      orderByName: 'createTime',
      orderByType: 'DESC',
    ));
    await loadEmployeeList();
  }

  /// 禁用/启用员工
  Future<void> toggleEmployeeStatus(
      String employeeId, EmployeeStatus status) async {
    final response = await employeeService.updateEmployee(employeeId, {
      'status': status.value,
    });
    if (response.code == HttpCode.success) {
      SportsToast.showSuccess(
          '${status.displayName == EmployeeStatus.Active.displayName ? '启用' : '禁用'}成功');
      pageNum = 1;
      await loadEmployeeList(isRefresh: true);
    } else {
      throw Exception(response.message ?? '${status.displayName}失败');
    }
  }

  /// 删除员工
  Future<void> deleteEmployee(String employeeId) async {
    // 调用API删除员工
    final response = await employeeService.deleteEmployee(employeeId);

    if (response.code == HttpCode.success) {
      SportsToast.showSuccess('删除成功');
      // 刷新员工列表
      await loadEmployeeList(isRefresh: true);
    }
  }

  /// 重置员工密码
  Future<RestEmployeeResponseData?> resetEmployeePassword(
      String employeeId) async {
    // 调用API重置员工密码
    final response = await employeeService.resetEmployeePassword(employeeId);

    if (response.code == HttpCode.success) {
      SportsToast.showSuccess('重置成功');
      return response.data;
    } else {
      throw Exception(response.message ?? '重置密码失败');
    }
  }

  /// 编辑员工信息
  Future<void> editEmployee(
      String employeeId, EmployeeEditRequest request) async {
    try {
      // 构建请求体
      final Map<String, dynamic> requestBody = {
        'username': request.username,
        'phone': request.phone,
        'roles': request.roles.map((role) => role.name).toList(),
      };

      // 如果有密码，则添加到请求体中
      if (request.password != null && request.password!.isNotEmpty) {
        requestBody['password'] = request.password;
      }

      // 如果有旧密码，则添加到请求体中
      if (request.oldPassword != null && request.oldPassword!.isNotEmpty) {
        requestBody['oldPassword'] = request.oldPassword;
      }

      // 调用API
      final response =
          await employeeService.updateEmployee(employeeId, requestBody);

      if (response.code == HttpCode.success) {
        // 刷新员工列表
        await loadEmployeeList(isRefresh: true);
      } else {
        throw Exception(response.message ?? '更新员工信息失败');
      }
    } catch (e) {
      l.e('EmployeeManagementCtrl', '员工信息编辑失败: $e');
      rethrow; // 将错误向上抛出，由UI层处理
    }
  }

  Future<void> addEmployee({
    required String username,
    required String phone,
    required String password,
    required EmployeeRole role,
    List<LotteryGiftConfig>? codeConf,
  }) async {
    final processedCodeConf = (codeConf ?? []).map((config) {
      if (config.type == LotteryTempCouponTypeEnum.dynamic) {
        // 随便传一个数字，后台不会校验
        return config.copyWith(num: '10');
      }
      return config;
    }).toList();

    // 构建请求体
    final Map<String, dynamic> requestBody = {
      'username': username,
      'phone': phone,
      'password': password,
      'roles': [role.toString().split('.').last], // 将枚举转为字符串 'employee'
      'codeConf': processedCodeConf.map((config) => config.toJson()).toList(),
    };

    // 调用API
    final response = await employeeService.createEmployee(requestBody);

    if (response.code == HttpCode.success) {
      // 刷新员工列表
      await loadEmployeeList(isRefresh: true);
    } else {
      throw Exception(response.message ?? '添加员工失败');
    }
  }

  /// 导航到编辑员工页面
  Future<void> navigateToEditEmployee(
      BuildContext context, String employeeId) async {
    final result = await context.pushNamed(
      'editEmployee',
      pathParameters: {'employeeId': employeeId},
    );

    // 如果编辑成功，刷新员工列表
    if (result == true) {
      await loadEmployeeList(isRefresh: true);
    }
  }

  /// 导航到新建员工页面
  Future<void> navigateToCreateEmployee(BuildContext context) async {
    final result = await context.pushNamed('createEmployee');

    // 如果创建成功，刷新员工列表
    if (result == true) {
      await loadEmployeeList(isRefresh: true);
    }
  }
}
