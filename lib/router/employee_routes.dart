import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottery_app/pages/employee_management/edit_employee/page.dart';

/// 员工管理相关路由
final List<RouteBase> employeeRoutes = [
  // 编辑员工页面
  GoRoute(
    path: '/editEmployee/:employeeId',
    name: 'editEmployee',
    builder: (BuildContext context, GoRouterState state) {
      final employeeId = state.pathParameters['employeeId'];
      return EditEmployeePage(employeeId: employeeId);
    },
  ),

  // 新建员工页面
  GoRoute(
    path: '/createEmployee',
    name: 'createEmployee',
    builder: (BuildContext context, GoRouterState state) {
      return const EditEmployeePage();
    },
  ),
];
