import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';

/// 统一的头部导航栏组件
class SportsAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 页面标题
  final String title;

  /// 自定义标题Widget
  final Widget? titleWidget;

  /// 返回按钮点击回调
  final VoidCallback? onBack;

  /// 右侧操作按钮
  final List<Widget>? actions;

  /// 是否显示返回按钮
  final bool showBackButton;

  /// 背景色
  final Color? backgroundColor;

  /// 标题颜色
  final Color? titleColor;

  /// 返回按钮颜色
  final Color? backButtonColor;

  /// 是否居中显示标题
  final bool centerTitle;

  /// 头部类型
  final SportsAppBarType type;

  const SportsAppBar({
    Key? key,
    required this.title,
    this.titleWidget,
    this.onBack,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.titleColor,
    this.backButtonColor,
    this.centerTitle = true,
    this.type = SportsAppBarType.light,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = _getTheme();

    return AppBar(
      automaticallyImplyLeading: false,
      title: titleWidget ??
          Text(
            title,
            style: SportsTextStyle.baseBold.copyWith(
              fontSize: pt(18),
              color: titleColor ?? theme.titleColor,
            ),
          ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.backgroundColor,
      elevation: theme.elevation,
      shadowColor: theme.shadowColor,
      systemOverlayStyle: theme.systemOverlayStyle,
      leading: showBackButton ? _buildBackButton(context, theme) : null,
      actions: actions,
    );
  }

  /// 构建返回按钮
  Widget _buildBackButton(BuildContext context, _AppBarTheme theme) {
    return GestureDetector(
      onTap: onBack ?? () => context.pop(),
      child: Container(
        alignment: Alignment.center,
        width: pt(40),
        height: pt(40),
        margin: EdgeInsets.only(left: pt(8)),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: pt(18),
          color: backButtonColor ?? theme.backButtonIconColor,
        ),
      ),
    );
  }

  /// 获取主题配置
  _AppBarTheme _getTheme() {
    switch (type) {
      case SportsAppBarType.light:
        return _AppBarTheme.light();
      case SportsAppBarType.dark:
        return _AppBarTheme.dark();
      case SportsAppBarType.transparent:
        return _AppBarTheme.transparent();
      case SportsAppBarType.gradient:
        return _AppBarTheme.gradient();
    }
  }
}

/// 头部栏类型
enum SportsAppBarType {
  /// 明亮主题 - 白色背景
  light,

  /// 深色主题 - 深色背景
  dark,

  /// 透明主题 - 透明背景
  transparent,

  /// 渐变主题 - 渐变背景
  gradient,
}

/// 头部栏主题配置
class _AppBarTheme {
  final Color backgroundColor;
  final Color titleColor;
  final Color backButtonIconColor;
  final Color? backButtonBackgroundColor;
  final List<BoxShadow>? backButtonShadow;
  final double elevation;
  final Color? shadowColor;
  final SystemUiOverlayStyle systemOverlayStyle;

  const _AppBarTheme({
    required this.backgroundColor,
    required this.titleColor,
    required this.backButtonIconColor,
    this.backButtonBackgroundColor,
    this.backButtonShadow,
    required this.elevation,
    this.shadowColor,
    required this.systemOverlayStyle,
  });

  /// 明亮主题
  factory _AppBarTheme.light() {
    return _AppBarTheme(
      backgroundColor: Colors.white,
      titleColor: AppColors.textPrimary,
      backButtonIconColor: AppColors.primary,
      backButtonBackgroundColor: AppColors.lightBlue,
      backButtonShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      elevation: 0.5,
      shadowColor: AppColors.divider,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  /// 深色主题
  factory _AppBarTheme.dark() {
    return _AppBarTheme(
      backgroundColor: AppColors.accentBlue,
      titleColor: Colors.white,
      backButtonIconColor: Colors.white,
      backButtonBackgroundColor: Colors.white.withValues(alpha: 0.15),
      backButtonShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      elevation: 2,
      shadowColor: Colors.black26,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  /// 透明主题
  factory _AppBarTheme.transparent() {
    return _AppBarTheme(
      backgroundColor: Colors.transparent,
      titleColor: AppColors.textPrimary,
      backButtonIconColor: AppColors.primary,
      backButtonBackgroundColor: Colors.white.withValues(alpha: 0.9),
      backButtonShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  /// 渐变主题
  factory _AppBarTheme.gradient() {
    return _AppBarTheme(
      backgroundColor: Colors.transparent,
      titleColor: Colors.white,
      backButtonIconColor: Colors.white,
      backButtonBackgroundColor: Colors.white.withValues(alpha: 0.2),
      backButtonShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}

/// 带渐变背景的头部栏
class SportsGradientAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// 页面标题
  final String title;

  /// 自定义标题Widget
  final Widget? titleWidget;

  /// 返回按钮点击回调
  final VoidCallback? onBack;

  /// 右侧操作按钮
  final List<Widget>? actions;

  /// 是否显示返回按钮
  final bool showBackButton;

  /// 渐变色
  final List<Color>? gradientColors;

  /// 标题颜色
  final Color? titleColor;

  /// 返回按钮颜色
  final Color? backButtonColor;

  /// 是否居中显示标题
  final bool centerTitle;

  const SportsGradientAppBar({
    Key? key,
    required this.title,
    this.titleWidget,
    this.onBack,
    this.actions,
    this.showBackButton = true,
    this.gradientColors,
    this.titleColor,
    this.backButtonColor,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        [
          AppColors.gradientStart,
          AppColors.gradientMiddle,
          AppColors.gradientEnd,
        ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: SportsAppBar(
        title: title,
        titleWidget: titleWidget,
        onBack: onBack,
        actions: actions,
        showBackButton: showBackButton,
        backgroundColor: Colors.transparent,
        titleColor: titleColor ?? Colors.white,
        backButtonColor: backButtonColor ?? Colors.white,
        centerTitle: centerTitle,
        type: SportsAppBarType.gradient,
      ),
    );
  }
}
