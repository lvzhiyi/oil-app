import 'package:lottery_app/pages/employee_management/model/common_type.dart';

import 'rest_employee_response_data.dart';

/// 员工列表API响应
class EmployeeListResponse {
  final int? code;
  final String? message;
  final EmployeeListData? data;

  EmployeeListResponse({
    this.code,
    this.message,
    this.data,
  });

  factory EmployeeListResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeListResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? EmployeeListData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// 员工列表数据
class EmployeeListData {
  final List<EmployeeInfo> list;
  final int total;

  EmployeeListData({
    required this.list,
    required this.total,
  });

  factory EmployeeListData.fromJson(Map<String, dynamic> json) {
    return EmployeeListData(
      list: (json['list'] as List)
          .map((item) => EmployeeInfo.fromJson(item))
          .toList(),
      total: json['total'] as int,
    );
  }
}

/// 员工API信息
class EmployeeApiInfo {
  final String uuid;
  final String username;
  final String phone;
  final List<EmployeeRole> roles;
  final int createTime;
  final int updateTime;
  final String status;

  EmployeeApiInfo({
    required this.uuid,
    required this.username,
    required this.phone,
    required this.roles,
    required this.createTime,
    required this.updateTime,
    required this.status,
  });

  factory EmployeeApiInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeApiInfo(
      uuid: json['uuid'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String,
      roles: (json['roles'] as List<dynamic>)
          .cast<String>()
          .map((e) => EmployeeRole.values.firstWhere((role) => role.name == e))
          .toList(),
      createTime: json['createTime'] as int,
      updateTime: json['updateTime'] as int,
      status: json['status'] as String,
    );
  }
}

/// 当前登录员工信息API响应
class CurrentEmployeeResponse {
  final int? code;
  final String? message;
  final CurrentEmployeeData? data;

  CurrentEmployeeResponse({
    this.code,
    this.message,
    this.data,
  });

  factory CurrentEmployeeResponse.fromJson(Map<String, dynamic> json) {
    return CurrentEmployeeResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? CurrentEmployeeData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class EmployeeGenCodeConf {
  final String? employeeUuid;
  final String? type;
  final String? num;
  final int? enable;

  EmployeeGenCodeConf({
    required this.employeeUuid,
    required this.type,
    required this.num,
    required this.enable,
  });

  factory EmployeeGenCodeConf.fromJson(Map<String, dynamic> json) {
    return EmployeeGenCodeConf(
      employeeUuid: json['employeeUuid'] as String,
      type: json['type'] as String,
      num: json['num'] as String,
      enable: json['enable'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeUuid': employeeUuid,
      'type': type,
      'num': num,
      'enable': enable,
    };
  }
}

/// 当前登录员工信息数据
class CurrentEmployeeData {
  final String? uuid;
  final String? username;
  final String? phone;
  final List<String>? roles;
  final List<EmployeeGenCodeConf>? codeConf;

  CurrentEmployeeData({
    required this.uuid,
    required this.username,
    required this.phone,
    required this.roles,
    required this.codeConf,
  });

  factory CurrentEmployeeData.fromJson(Map<String, dynamic> json) {
    return CurrentEmployeeData(
      uuid: json['uuid'] as String,
      username: json['username'] as String? ?? '',
      phone: json['phone'] as String,
      roles: (json['roles'] as List<dynamic>).cast<String>().toList(),
      codeConf: (json['codeConf'] as List<dynamic>)
          .map((e) => EmployeeGenCodeConf.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'phone': phone,
      'roles': roles,
      'codeConf': codeConf?.map((e) => e.toJson()).toList(),
    };
  }
}

/// 创建员工API响应
class CreateEmployeeResponse {
  final int? code;
  final String? message;
  final Map<String, dynamic>? data;

  CreateEmployeeResponse({this.code, this.message, this.data});

  factory CreateEmployeeResponse.fromJson(Map<String, dynamic> json) {
    return CreateEmployeeResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null ? json['data'] as Map<String, dynamic> : null,
    );
  }
}

class RestEmployeePasswordResponse {
  final int? code;
  final String? message;
  final RestEmployeeResponseData? data;

  RestEmployeePasswordResponse({this.code, this.message, this.data});

  factory RestEmployeePasswordResponse.fromJson(Map<String, dynamic> json) {
    return RestEmployeePasswordResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? RestEmployeeResponseData.fromJson(
              json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// 员工详情数据
class EmployeeDetailData {
  final String uuid;
  final String username;
  final String phone;
  final String account; // 账号
  /// 角色
  final List<EmployeeRole> roles;

  /// 彩票赠送权限配置
  final List<LotteryGiftConfig> codeConf;

  EmployeeDetailData({
    required this.uuid,
    required this.username,
    required this.phone,
    required this.account,
    required this.roles,
    required this.codeConf,
  });

  factory EmployeeDetailData.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailData(
      uuid: json['uuid'] as String,
      username: json['username'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      account: json['account'] as String? ?? '',
      roles: ((json['roles'] as List?)?.cast<String>() ??
              const <String>[]) // 兼容后端可能返回null
          .map((e) => EmployeeRole.values.firstWhere((role) => role.name == e,
              orElse: () => EmployeeRole.employee))
          .toList(),
      codeConf: ((json['codeConf'] as List?)?.cast<Map<String, dynamic>>() ??
              const <Map<String, dynamic>>[]) // 兼容后端可能返回null
          .map((e) => LotteryGiftConfig.fromJson(e))
          .toList(),
    );
  }
}

/// 员工详情API响应
class EmployeeDetailResponse {
  final int? code;
  final String? message;
  final EmployeeDetailData? data;

  EmployeeDetailResponse({this.code, this.message, this.data});

  factory EmployeeDetailResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? EmployeeDetailData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
