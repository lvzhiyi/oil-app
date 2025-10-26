import 'package:lottery_app/global/enum/common.dart';

/// 员工权限类型
enum EmployeeRole {
  employee('员工'),
  admin('管理员'),
  owner('老板');

  const EmployeeRole(this.displayName);

  final String displayName;
}

/// 彩票赠送权限配置
class LotteryGiftConfig {
  /// 彩票类型
  final LotteryTempCouponTypeEnum type;
  
  /// 数量
  final String num;
  
  /// 是否启用
  final int enable;

  const LotteryGiftConfig({
    required this.type,
    required this.num,
    required this.enable,
  });

  factory LotteryGiftConfig.fromJson(Map<String, dynamic> json) {
    return LotteryGiftConfig(
      type: LotteryTempCouponTypeEnum.fromValue(json['type'] as String),
      num: json['num'] as String,
      enable: json['enable'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'num': num,
      'enable': enable,
    };
  }

  LotteryGiftConfig copyWith({
    LotteryTempCouponTypeEnum? type,
    String? num,
    int? enable,
  }) {
    return LotteryGiftConfig(
      type: type ?? this.type,
      num: num ?? this.num,
      enable: enable ?? this.enable,
    );
  }
}

/// 员工信息
class EmployeeInfo {
  final String uuid;
  final String username;
  final String phone;
  final List<EmployeeRole> roles;
  final int createTime;
  final int updateTime;
  final EmployeeStatus status;

  const EmployeeInfo({
    required this.uuid,
    required this.username,
    required this.phone,
    required this.roles,
    required this.createTime,
    required this.updateTime,
    required this.status,
  });

  EmployeeInfo copyWith({
    String? uuid,
    String? username,
    String? phone,
    List<EmployeeRole>? roles,
    int? createTime,
    int? updateTime,
    EmployeeStatus? status,
  }) {
    return EmployeeInfo(
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      roles: roles ?? this.roles,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      status: status ?? this.status,
    );
  }

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      uuid: json['uuid'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String,
      roles: (json['roles'] as List)
          .map((role) => EmployeeRole.values.byName(role))
          .toList(),
      createTime: json['createTime'] as int,
      updateTime: json['updateTime'] as int,
      status: EmployeeStatus.values
          .firstWhere((status) => status.value == json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'phone': phone,
      'roles': roles.map((role) => role.name).toList(),
      'createTime': createTime,
      'updateTime': updateTime,
      'status': status.value,
    };
  }
}

/// 员工编辑请求
class EmployeeEditRequest {
  final String uuid;
  final String username;
  final String phone;
  final List<EmployeeRole> roles;
  final String? password; // 新密码，可选
  final String? oldPassword; // 旧密码，可选

  const EmployeeEditRequest({
    required this.uuid,
    required this.username,
    required this.phone,
    required this.roles,
    this.password,
    this.oldPassword,
  });
}

/// 员工创建请求
class EmployeeCreateRequest {
  final String username;
  final String phone;
  final String password;
  final List<EmployeeRole> roles;

  const EmployeeCreateRequest({
    required this.username,
    required this.phone,
    required this.password,
    required this.roles,
  });
}
