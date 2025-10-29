import 'package:oil_business_app/global/model/user_profile_type.dart';

class ProfileState {
  /// 是否正在加载
  bool isLoading;

  /// 是否有错误
  bool hasError;

  /// 错误信息
  String? errorMessage;

  /// 用户信息
  UserProfile? userProfile;

  /// 开放平台配置
  OpenPlatformConfig? openPlatformConfig;

  /// 是否正在退出登录
  bool isLoggingOut;

  /// 退出登录是否成功
  bool logoutSuccess;

  /// 是否正在更新个人信息
  bool isUpdatingProfile;

  /// 是否正在修改密码
  bool isChangingPassword;

  ProfileState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.userProfile,
    this.openPlatformConfig,
    this.isLoggingOut = false,
    this.logoutSuccess = false,
    this.isUpdatingProfile = false,
    this.isChangingPassword = false,
  });

  /// 是否是首次加载
  bool get isFirstLoad => userProfile == null && !hasError;

  ProfileState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    UserProfile? userProfile,
    OpenPlatformConfig? openPlatformConfig,
    bool? isLoggingOut,
    bool? logoutSuccess,
    bool? isUpdatingProfile,
    bool? isChangingPassword,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      userProfile: userProfile ?? this.userProfile,
      openPlatformConfig: openPlatformConfig ?? this.openPlatformConfig,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      logoutSuccess: logoutSuccess ?? this.logoutSuccess,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
      isChangingPassword: isChangingPassword ?? this.isChangingPassword,
    );
  }
}
