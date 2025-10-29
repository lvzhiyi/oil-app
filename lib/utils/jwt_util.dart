import 'dart:convert';
import 'package:oil_business_app/utils/log.dart';

/// JWT工具类
///
/// 提供JWT token的解析和验证功能
/// 支持：
/// - token过期时间检查
/// - payload解析
/// - 格式验证
class JWTUtil {
  /// 解析JWT token的payload部分
  ///
  /// JWT格式：header.payload.signature
  /// 返回解析后的payload Map，失败返回null
  static Map<String, dynamic>? parsePayload(String token) {
    try {
      // JWT由三部分组成，用.分隔
      final parts = token.split('.');
      if (parts.length != 3) {
        l.w('JWTUtil', 'JWT格式错误: 不是3个部分');
        return null;
      }

      // 获取payload部分（第二部分）
      String payload = parts[1];

      // Base64 URL解码需要处理padding
      switch (payload.length % 4) {
        case 0:
          break;
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
        default:
          l.w('JWTUtil', 'Base64解码失败: padding错误');
          return null;
      }

      // 将Base64 URL替换为标准Base64
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');

      // Base64解码
      final bytes = base64Decode(payload);
      final jsonString = utf8.decode(bytes);

      // JSON解析
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      l.e('JWTUtil', 'JWT解析失败: $e');
      return null;
    }
  }

  /// 检查token是否过期
  ///
  /// 返回true表示已过期，false表示有效
  /// 如果无法解析token，返回true（认为过期）
  static bool isTokenExpired(String token) {
    try {
      final payload = parsePayload(token);
      if (payload == null) {
        l.w('JWTUtil', '无法解析token payload，认为已过期');
        return true;
      }

      // 获取过期时间（exp字段，Unix时间戳）
      final exp = payload['exp'];
      if (exp == null) {
        l.w('JWTUtil', 'token中没有exp字段，认为已过期');
        return true;
      }

      // 转换为DateTime
      final expiryTime = DateTime.fromMillisecondsSinceEpoch(
        (exp as int) * 1000,
      );

      final now = DateTime.now();
      final isExpired = now.isAfter(expiryTime);

      if (isExpired) {
        l.d('JWTUtil', 'token已过期: 过期时间=$expiryTime, 当前时间=$now');
      } else {
        final remainingTime = expiryTime.difference(now);
        l.d('JWTUtil', 'token有效，剩余时间: ${remainingTime.inMinutes}分钟');
      }

      return isExpired;
    } catch (e) {
      l.e('JWTUtil', '检查token过期时间失败: $e');
      return true; // 异常情况认为已过期
    }
  }

  /// 获取token的剩余有效时间
  ///
  /// 返回Duration，如果token无效或已过期返回null
  static Duration? getRemainingTime(String token) {
    try {
      final payload = parsePayload(token);
      if (payload == null) return null;

      final exp = payload['exp'];
      if (exp == null) return null;

      final expiryTime = DateTime.fromMillisecondsSinceEpoch(
        (exp as int) * 1000,
      );

      final now = DateTime.now();
      if (now.isAfter(expiryTime)) {
        return null; // 已过期
      }

      return expiryTime.difference(now);
    } catch (e) {
      l.e('JWTUtil', '获取剩余时间失败: $e');
      return null;
    }
  }

  /// 检查token是否即将过期
  ///
  /// [thresholdMinutes] 阈值时间（分钟），默认5分钟
  /// 返回true表示即将过期，建议提前刷新
  static bool isTokenExpiringSoon(String token, {int thresholdMinutes = 5}) {
    final remainingTime = getRemainingTime(token);
    if (remainingTime == null) return true;

    return remainingTime.inMinutes <= thresholdMinutes;
  }

  /// 获取token中的用户信息
  ///
  /// 尝试从token payload中提取常见的用户字段
  static Map<String, dynamic>? getUserInfo(String token) {
    final payload = parsePayload(token);
    if (payload == null) return null;

    // 提取常见的用户信息字段
    final userInfo = <String, dynamic>{};

    // 常见字段列表
    const userFields = [
      'sub',
      'user_id',
      'userId',
      'id',
      'username',
      'email',
      'phone',
      'tenant_id',
      'tenantId',
      'role',
      'roles'
    ];

    for (final field in userFields) {
      if (payload.containsKey(field)) {
        userInfo[field] = payload[field];
      }
    }

    return userInfo.isNotEmpty ? userInfo : null;
  }

  /// 验证token格式是否正确
  ///
  /// 仅检查格式，不验证签名
  static bool isValidFormat(String token) {
    if (token.isEmpty) return false;

    final parts = token.split('.');
    if (parts.length != 3) return false;

    // 简单检查每个部分是否为空
    return parts.every((part) => part.isNotEmpty);
  }
}
