import 'package:lottery_app/global/enum/common.dart';

/// 代理商余额信息
class AgentBalance {
  final int type;
  final String balance;

  AgentBalance({
    required this.type,
    required this.balance,
  });

  factory AgentBalance.fromJson(Map<String, dynamic> json) {
    return AgentBalance(
      type: json['type'] as int,
      balance: json['balance'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'balance': balance,
    };
  }
}

/// 代理商信息
class AgentInfo {
  final String name;
  final String phone;
  final String contactName;
  final String industry;
  final String balance;
  final int createTime;
  final Map<String, dynamic> packageBalance;
  final String clientKey;
  final String clientSecret;
  final List<LotteryConfig> lotteryConfig;
  final String miniDepositAmount;

  AgentInfo({
    required this.name,
    required this.phone,
    required this.contactName,
    required this.industry,
    required this.balance,
    required this.createTime,
    required this.packageBalance,
    required this.clientKey,
    required this.clientSecret,
    required this.lotteryConfig,
    required this.miniDepositAmount,
  });

  factory AgentInfo.fromJson(Map<String, dynamic> json) {
    return AgentInfo(
      name: json['name'] as String,
      phone: json['phone'] as String,
      contactName: json['contactName'] as String,
      industry: json['industry'] as String,
      balance: json['balance'] as String,
      createTime: json['createTime'] as int,
      packageBalance: json['packageBalance'] as Map<String, dynamic>,
      clientKey: json['clientKey'] as String,
      clientSecret: json['clientSecret'] as String,
      lotteryConfig: (json['lotteryConfig'] as List)
          .map((e) => LotteryConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      miniDepositAmount: json['miniDepositAmount'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'contactName': contactName,
      'industry': industry,
      'balance': balance,
      'createTime': createTime,
      'packageBalance': packageBalance,
      'clientKey': clientKey,
      'clientSecret': clientSecret,
      'lotteryConfig': lotteryConfig.map((e) => e.toJson()).toList(),
      'miniDepositAmount': miniDepositAmount,
    };
  }
}

class UpdateAgentInfoRequest {
  final String contactName;
  final String phone;

  UpdateAgentInfoRequest({
    required this.contactName,
    required this.phone,
  });

  factory UpdateAgentInfoRequest.fromJson(Map<String, dynamic> json) {
    return UpdateAgentInfoRequest(
      contactName: json['contactName'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactName': contactName,
      'phone': phone,
    };
  }
}

class LotteryConfig {
  final String tenantUuid;
  final LotteryType lotteryType;
  final String unitPrice;

  LotteryConfig({
    required this.tenantUuid,
    required this.lotteryType,
    required this.unitPrice,
  });

  factory LotteryConfig.fromJson(Map<String, dynamic> json) {
    return LotteryConfig(
      tenantUuid: json['tenantUuid'] as String,
      lotteryType: LotteryType.fromValue(json['lotteryType'] as int),
      unitPrice: json['unitPrice'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantUuid': tenantUuid,
      'lotteryType': lotteryType.value,
      'unitPrice': unitPrice,
    };
  }
}

/// 代理商信息API响应
class AgentInfoResponse {
  final int? code;
  final String? message;
  final AgentInfo? data;

  AgentInfoResponse({this.code, this.message, this.data});

  factory AgentInfoResponse.fromJson(Map<String, dynamic> json) {
    return AgentInfoResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? AgentInfo.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
