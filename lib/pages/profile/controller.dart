import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/global/model/user_profile_type.dart';
import 'package:oil_business_app/pages/profile/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/token_manager.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';
import 'package:oil_business_app/utils/log.dart';

class ProfileCtrl extends Cubit<ProfileState> {
  final EasyRefreshController refreshController = EasyRefreshController();
  ProfileCtrl() : super(ProfileState()) {
    initState();
  }

  initState() async {
    await loadUserProfile();
    await loadOpenPlatformConfig();
  }

  /// 加载用户信息
  Future<void> loadUserProfile() async {
    emit(state.copyWith()..isLoading = true);

    try {
      /// 从本地存储获取当前用户信息和代理商信息

      emit(state.copyWith()
        ..isLoading = false
        ..hasError = false
        ..errorMessage = null);
    } catch (e) {
      l.e('ProfileCtrl', '加载用户信息失败: $e');
      emit(state.copyWith()
        ..isLoading = false
        ..hasError = true
        ..errorMessage = e.toString());
    }
  }

  /// 加载开放平台配置
  Future<void> loadOpenPlatformConfig() async {
    try {
      // 模拟API调用延迟
      await Future.delayed(const Duration(milliseconds: 500));

      const mockConfig = OpenPlatformConfig(
        apiKey: 'sk_test_12345678901234567890',
        ipWhitelist: ['192.168.1.1', '10.0.0.1'],
        dailyCallLimit: 10000,
        todayCallCount: 1250,
        enabled: true,
      );

      emit(state.copyWith()..openPlatformConfig = mockConfig);
    } catch (e) {
      debugPrint('加载开放平台配置失败: $e');
    }
  }

  /// 更新联系人信息
  Future<bool> updateContactInfo({
    required String contactName,
    required String contactPhone,
  }) async {
    emit(state.copyWith()..isUpdatingProfile = true);

    try {
      // 模拟API调用延迟
      await Future.delayed(const Duration(seconds: 1));

      // 模拟更新成功，重新加载用户信息
      final currentUser = state.userProfile;
      if (currentUser != null) {
        // 创建更新后的用户信息（在实际项目中这应该从服务端获取）
        final updatedUser = UserProfile(
          id: currentUser.id,
          username: currentUser.username,
          contactName: contactName,
          contactPhone: contactPhone,
          role: currentUser.role,
          permissions: currentUser.permissions,
          balance: currentUser.balance,
          lotteryCount: currentUser.lotteryCount,
          registrationTime: currentUser.registrationTime,
          avatar: currentUser.avatar,
          enabled: currentUser.enabled,
          tenantUuid: currentUser.tenantUuid,
        );

        emit(state.copyWith()
          ..isUpdatingProfile = false
          ..userProfile = updatedUser);
      }

      SportsToast.showSuccess('个人信息更新成功');
      return true;
    } catch (e) {
      emit(state.copyWith()
        ..isUpdatingProfile = false
        ..hasError = true
        ..errorMessage = e.toString());
      SportsToast.showError('个人信息更新失败: ${e.toString()}');
      return false;
    }
  }

  /// 修改密码
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(state.copyWith()..isChangingPassword = true);

    try {
      // 模拟API调用延迟
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith()..isChangingPassword = false);
      SportsToast.showSuccess('密码修改成功');
      return true;
    } catch (e) {
      emit(state.copyWith()
        ..isChangingPassword = false
        ..hasError = true
        ..errorMessage = e.toString());
      SportsToast.showError('密码修改失败: ${e.toString()}');
      return false;
    }
  }

  /// 更新开放平台配置
  Future<bool> updateOpenPlatformConfig({
    required List<String> ipWhitelist,
    required int dailyCallLimit,
    required bool enabled,
  }) async {
    try {
      // 模拟API调用延迟
      await Future.delayed(const Duration(seconds: 1));

      // 重新加载配置
      await loadOpenPlatformConfig();
      SportsToast.showSuccess('开放平台配置更新成功');
      return true;
    } catch (e) {
      SportsToast.showError('开放平台配置更新失败: ${e.toString()}');
      return false;
    }
  }

  /// 重新生成API Key
  Future<String?> regenerateApiKey() async {
    try {
      // 模拟API调用延迟
      await Future.delayed(const Duration(seconds: 1));

      const newApiKey = 'sk_test_new_12345678901234567890';

      // 重新加载配置以获取最新的API Key
      await loadOpenPlatformConfig();
      SportsToast.showSuccess('API Key重新生成成功');
      return newApiKey;
    } catch (e) {
      SportsToast.showError('API Key重新生成失败: ${e.toString()}');
      return null;
    }
  }

  /// 退出登录
  Future<void> logout() async {
    emit(state.copyWith()..isLoggingOut = true);

    try {
      // 模拟API调用延迟
      await Future.delayed(const Duration(seconds: 1));
      await TokenManager.instance.clearAuth();
      // 清理本地状态
      BaseRouter.replace(url: AppPage.loginPage.path);
      emit(state.copyWith()
        ..isLoggingOut = false
        ..logoutSuccess = true);
    } catch (e) {
      emit(state.copyWith()
        ..isLoggingOut = false
        ..hasError = true
        ..errorMessage = e.toString());

      // 即使服务端退出失败，也要清理本地状态
    }
  }

  /// 刷新用户信息
  Future<void> refreshProfile() async {
    // 然后刷新个人页面的信息
    await loadUserProfile();
    await loadOpenPlatformConfig();
  }

  /// 检查用户权限
  bool hasPermission(String permission) {
    final userProfile = state.userProfile;
    if (userProfile == null) return false;

    final permissions = userProfile.permissions;
    switch (permission) {
      case 'canManageEmployees':
        return permissions.canManageEmployees;
      case 'canRecharge':
        return permissions.canRecharge;
      case 'canExportData':
        return permissions.canExportData;
      case 'canSetManager':
        return permissions.canSetManager;
      case 'canDisableEmployee':
        return permissions.canDisableEmployee;
      default:
        return false;
    }
  }

  /// 获取用户角色显示名称
  String get userRoleDisplayName {
    return state.userProfile?.role.displayName ?? '未知';
  }

  /// 是否为老板
  bool get isBoss {
    return state.userProfile?.role == UserRole.owner;
  }

  /// 是否为管理员或老板
  bool get isManagerOrBoss {
    final role = state.userProfile?.role;
    return role == UserRole.manager || role == UserRole.owner;
  }

  /// 导航到员工管理页面
  void navigateToEmployeeManagement(BuildContext context) {
    context.push('/employeeManagement');
  }

  /// 导航到赠送记录页面
  void navigateToGiftRecords(BuildContext context) {
    context.push('/giftRecords');
  }

  /// 导航到修改密码页面
  void navigateToChangePassword(BuildContext context) {
    context.push('/changePassword');
  }

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }
}
