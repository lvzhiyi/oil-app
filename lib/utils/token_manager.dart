import 'package:oil_business_app/global/storage.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/utils/jwt_util.dart';

/// Token管理器
///
/// 支持双token机制：
/// - access_token: 用于API访问的短期token
/// - refresh_token: 用于刷新access_token的长期token
/// - tenantUuid: 代理商标识
///
/// 安全特性：
/// - refresh token轮换检测
/// - token使用监控
/// - 异常使用检测
class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tenantUuidKey = 'tenant_uuid';
  static const String _userInfoKey = 'user_info';
  static const String _refreshTokenUsedKey = 'refresh_token_used';
  static const String _lastRefreshTimeKey = 'last_refresh_time';
  static const String _refreshCountKey = 'refresh_count';

  static TokenManager? _instance;
  static TokenManager get instance => _instance ??= TokenManager._();

  TokenManager._();

  /// 保存access token
  Future<void> saveAccessToken(String accessToken) async {
    await GlobalStorage.sportsSingleton.put(_accessTokenKey, accessToken);
  }

  /// 保存refresh token
  /// 支持轮换检测，每次保存新token时会记录相关信息
  Future<void> saveRefreshToken(String refreshToken) async {
    final oldRefreshToken = getRefreshToken();

    // 保存新的refresh token
    await GlobalStorage.sportsSingleton.put(_refreshTokenKey, refreshToken);

    // 如果这是一个新的refresh token（不同于旧的），则重置使用状态
    if (oldRefreshToken != refreshToken) {
      await GlobalStorage.sportsSingleton.put(_refreshTokenUsedKey, false);
      await GlobalStorage.sportsSingleton
          .put(_lastRefreshTimeKey, DateTime.now().millisecondsSinceEpoch);

      // 增加刷新计数
      final currentCount = getRefreshCount();
      await GlobalStorage.sportsSingleton
          .put(_refreshCountKey, currentCount + 1);

      l.d('TokenManager', '保存新的refresh token，刷新次数: ${currentCount + 1}');
    }
  }

  /// 保存代理商UUID
  Future<void> saveTenantUuid(String tenantUuid) async {
    await GlobalStorage.sportsSingleton.put(_tenantUuidKey, tenantUuid);
  }

  /// 保存用户信息
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    await GlobalStorage.sportsSingleton.put(_userInfoKey, userInfo);
  }

  /// 获取access token
  String? getAccessToken() {
    return GlobalStorage.sportsSingleton.get(_accessTokenKey);
  }

  /// 获取refresh token
  String? getRefreshToken() {
    return GlobalStorage.sportsSingleton.get(_refreshTokenKey);
  }

  /// 获取代理商UUID
  String? getTenantUuid() {
    return GlobalStorage.sportsSingleton.get(_tenantUuidKey);
  }

  /// 获取用户信息
  Map<String, dynamic>? getUserInfo() {
    return GlobalStorage.sportsSingleton.get(_userInfoKey);
  }

  /// 检查是否已登录
  ///
  /// 不仅检查token存在，还验证token是否有效（未过期）
  bool isLoggedIn() {
    final accessToken = getAccessToken();
    final tenantUuid = getTenantUuid();

    if (accessToken == null ||
        accessToken.isEmpty ||
        tenantUuid == null ||
        tenantUuid.isEmpty) {
      return false;
    }

    // 检查access token是否过期
    if (JWTUtil.isTokenExpired(accessToken)) {
      l.d('TokenManager', 'access token已过期');
      return false;
    }

    return true;
  }

  /// 检查access token是否即将过期
  ///
  /// [thresholdMinutes] 阈值时间（分钟），默认5分钟
  /// 返回true表示即将过期，建议提前刷新
  bool isAccessTokenExpiringSoon({int thresholdMinutes = 5}) {
    final accessToken = getAccessToken();
    if (accessToken == null) return true;

    return JWTUtil.isTokenExpiringSoon(accessToken,
        thresholdMinutes: thresholdMinutes);
  }

  /// 获取access token的剩余有效时间
  Duration? getAccessTokenRemainingTime() {
    final accessToken = getAccessToken();
    if (accessToken == null) return null;

    return JWTUtil.getRemainingTime(accessToken);
  }

  /// 检查refresh token是否过期
  bool isRefreshTokenExpired() {
    final refreshToken = getRefreshToken();
    if (refreshToken == null) return true;

    return JWTUtil.isTokenExpired(refreshToken);
  }

  /// 从access token中提取用户信息
  Map<String, dynamic>? getUserInfoFromToken() {
    final accessToken = getAccessToken();
    if (accessToken == null) return null;

    return JWTUtil.getUserInfo(accessToken);
  }

  /// 验证token格式
  bool validateTokenFormat() {
    final accessToken = getAccessToken();
    final refreshToken = getRefreshToken();

    if (accessToken != null && !JWTUtil.isValidFormat(accessToken)) {
      l.w('TokenManager', 'access token格式无效');
      return false;
    }

    if (refreshToken != null && !JWTUtil.isValidFormat(refreshToken)) {
      l.w('TokenManager', 'refresh token格式无效');
      return false;
    }

    return true;
  }

  /// 检查refresh token是否已被使用
  /// 用于检测token重用攻击
  bool isRefreshTokenUsed() {
    return GlobalStorage.sportsSingleton.get(_refreshTokenUsedKey) ?? false;
  }

  /// 标记refresh token为已使用
  /// 在每次使用refresh token时调用，用于检测重用
  Future<void> markRefreshTokenAsUsed() async {
    await GlobalStorage.sportsSingleton.put(_refreshTokenUsedKey, true);
    l.d('TokenManager', 'refresh token已标记为使用');
  }

  /// 获取上次刷新时间
  DateTime? getLastRefreshTime() {
    final timestamp = GlobalStorage.sportsSingleton.get(_lastRefreshTimeKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  /// 获取refresh计数
  int getRefreshCount() {
    return GlobalStorage.sportsSingleton.get(_refreshCountKey) ?? 0;
  }

  /// 检测异常的refresh行为
  /// 如果refresh频率过高，可能存在安全风险
  bool detectAbnormalRefreshBehavior() {
    final lastRefreshTime = getLastRefreshTime();
    final refreshCount = getRefreshCount();

    if (lastRefreshTime != null) {
      final timeSinceLastRefresh = DateTime.now().difference(lastRefreshTime);

      // 如果在5分钟内刷新超过10次，认为异常
      if (timeSinceLastRefresh.inMinutes < 5 && refreshCount > 10) {
        l.w('TokenManager', '检测到异常refresh行为: $refreshCount次/5分钟');
        return true;
      }

      // 如果1分钟内刷新超过5次，认为异常
      if (timeSinceLastRefresh.inMinutes < 1 && refreshCount > 5) {
        l.w('TokenManager', '检测到高频refresh行为: $refreshCount次/1分钟');
        return true;
      }
    }

    return false;
  }

  /// 清除所有认证信息
  Future<void> clearAuth() async {
    l.d('TokenManager', '清除所有认证信息');
    await GlobalStorage.sportsSingleton.delete(_accessTokenKey);
    await GlobalStorage.sportsSingleton.delete(_refreshTokenKey);
    await GlobalStorage.sportsSingleton.delete(_tenantUuidKey);
    await GlobalStorage.sportsSingleton.delete(_userInfoKey);
    await GlobalStorage.sportsSingleton.delete(_refreshTokenUsedKey);
    await GlobalStorage.sportsSingleton.delete(_lastRefreshTimeKey);
    await GlobalStorage.sportsSingleton.delete(_refreshCountKey);
  }

  /// 兼容性方法 - 保存token (实际保存access_token)
  @Deprecated('使用 saveAccessToken 替代')
  Future<void> saveToken(String token) async {
    await saveAccessToken(token);
  }

  /// 兼容性方法 - 获取token (实际获取access_token)
  @Deprecated('使用 getAccessToken 替代')
  String? getToken() {
    return getAccessToken();
  }
}
