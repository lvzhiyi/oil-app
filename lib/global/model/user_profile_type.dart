/// 用户角色枚举
enum UserRole {
  /// 普通员工
  employee('employee', '员工'),

  /// 管理员
  manager('manager', '管理员'),

  /// 超级管理员
  owner('owner', '超级管理员');

  const UserRole(this.value, this.displayName);
  final String value;
  final String displayName;
}

/// 用户权限
class UserPermissions {
  /// 是否可以查看员工管理
  final bool canManageEmployees;

  /// 是否可以充值
  final bool canRecharge;

  /// 是否可以导出数据
  final bool canExportData;

  /// 是否可以设置管理员
  final bool canSetManager;

  /// 是否可以禁用员工
  final bool canDisableEmployee;

  const UserPermissions({
    this.canManageEmployees = false,
    this.canRecharge = false,
    this.canExportData = false,
    this.canSetManager = false,
    this.canDisableEmployee = false,
  });

  factory UserPermissions.fromJson(Map<String, dynamic> json) {
    return UserPermissions(
      canManageEmployees: json['canManageEmployees'] ?? false,
      canRecharge: json['canRecharge'] ?? false,
      canExportData: json['canExportData'] ?? false,
      canSetManager: json['canSetManager'] ?? false,
      canDisableEmployee: json['canDisableEmployee'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canManageEmployees': canManageEmployees,
      'canRecharge': canRecharge,
      'canExportData': canExportData,
      'canSetManager': canSetManager,
      'canDisableEmployee': canDisableEmployee,
    };
  }
}

/// 用户个人信息
class UserProfile {
  /// 用户ID
  final String id;

  /// 我的名称（账号，不可修改）
  final String username;

  /// 联系人姓名（可修改）
  final String contactName;

  /// 联系电话（可修改）
  final String contactPhone;

  /// 用户角色
  final UserRole role;

  /// 用户权限
  final UserPermissions permissions;

  /// 当前余额
  final String balance;

  /// 彩票权益数量
  final int lotteryCount;

  /// 注册时间
  final DateTime registrationTime;

  /// 头像URL
  final String? avatar;

  /// 是否启用
  final bool enabled;

  /// 代理商UUID
  final String tenantUuid;

  const UserProfile({
    required this.id,
    required this.username,
    required this.contactName,
    required this.contactPhone,
    required this.role,
    required this.permissions,
    this.balance = '0.0',
    this.lotteryCount = 0,
    required this.registrationTime,
    this.avatar,
    this.enabled = true,
    required this.tenantUuid,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      contactName: json['contactName'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.value == json['role'],
        orElse: () => UserRole.employee,
      ),
      permissions: UserPermissions.fromJson(json['permissions'] ?? {}),
      balance: (json['balance'] ?? 0.0).toDouble(),
      lotteryCount: json['lotteryCount'] ?? 0,
      registrationTime: DateTime.parse(
          json['registrationTime'] ?? DateTime.now().toIso8601String()),
      avatar: json['avatar'],
      enabled: json['enabled'] ?? true,
      tenantUuid: json['tenantUuid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'role': role.value,
      'permissions': permissions.toJson(),
      'balance': balance,
      'lotteryCount': lotteryCount,
      'registrationTime': registrationTime.toIso8601String(),
      'avatar': avatar,
      'enabled': enabled,
      'tenantUuid': tenantUuid,
    };
  }
}

/// 开放平台配置
class OpenPlatformConfig {
  /// API KEY
  final String apiKey;

  /// IP白名单
  final List<String> ipWhitelist;

  /// 每日调用次数上限
  final int dailyCallLimit;

  /// 今日已调用次数
  final int todayCallCount;

  /// 是否启用
  final bool enabled;

  const OpenPlatformConfig({
    required this.apiKey,
    this.ipWhitelist = const [],
    this.dailyCallLimit = 10000,
    this.todayCallCount = 0,
    this.enabled = false,
  });

  factory OpenPlatformConfig.fromJson(Map<String, dynamic> json) {
    return OpenPlatformConfig(
      apiKey: json['apiKey'] ?? '',
      ipWhitelist: List<String>.from(json['ipWhitelist'] ?? []),
      dailyCallLimit: json['dailyCallLimit'] ?? 10000,
      todayCallCount: json['todayCallCount'] ?? 0,
      enabled: json['enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apiKey': apiKey,
      'ipWhitelist': ipWhitelist,
      'dailyCallLimit': dailyCallLimit,
      'todayCallCount': todayCallCount,
      'enabled': enabled,
    };
  }
}
