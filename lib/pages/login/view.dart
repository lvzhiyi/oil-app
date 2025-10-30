import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/pages/login/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/platform.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/common/image_asset_pro.dart';
import 'package:oil_business_app/widgets/common/inputs/mobile_number.dart';
import 'package:oil_business_app/widgets/common/inputs/password.dart';

import 'controller.dart';

class LoginView extends StatefulWidget {
  final LoginState state;

  const LoginView({super.key, required this.state});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  FocusNode passwordFocusNode = FocusNode();

  /// 请求获取密码输入框键盘的焦点，调起系统键盘
  void requestFocusPassword() {
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<LoginCtrl>();

    return BlocListener<LoginCtrl, LoginState>(
      listener: (context, state) {
        if (state.loginSuccess) {
          // 使用WidgetsBinding.instance.addPostFrameCallback避免在构建期间导航
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ctrl.navigateToHome(context);
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            ctrl.unFocus(context);
          },
          child: Container(
            decoration: _buildBackgroundGradient(),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: pt(48)),
                          _buildLogoSection(),
                          SizedBox(height: pt(40)),
                          _buildLoginForm(),
                          _buildErrorDisplay(),
                          SizedBox(height: pt(16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildLoginOtherLink('忘记密码？', () {
                                BaseRouter.push(
                                    url: AppPage.changePasswordPage.path);
                              }),
                              _buildLoginOtherLink('注册', () {
                                BaseRouter.push(url: AppPage.registerPage.path);
                              }),
                            ],
                          ),
                          SizedBox(height: pt(32)),
                          _buildLoginButton(ctrl),
                          SizedBox(height: pt(48)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建背景 - 纯净白色背景
  BoxDecoration _buildBackgroundGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFF8FAFF),
          Color(0xFFFFFFFF),
        ],
      ),
    );
  }

  /// 构建Logo区域 - 参考优秀设计
  Widget _buildLogoSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: pt(80),
          height: pt(80),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(pt(20)),
          ),
          child: ImageAsset(
            assetName: AssetsImg.LOGO,
            width: pt(36),
            height: pt(36),
            borderRadius: pt(18),
          ),
        ),
        SizedBox(height: pt(12)),
        Text(
          '代理商管理，触手可及',
          style: SportsTextStyle.baseNormal.copyWith(
            fontSize: pt(16),
            color: const Color(0xFF8B8B8B),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// 构建登录表单 - 极简卡片设计
  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(pt(24)),
      margin: EdgeInsets.symmetric(horizontal: pt(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(12)),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: pt(1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F7CF7).withValues(alpha: 0.05),
            blurRadius: pt(10),
            offset: Offset(0, pt(2)),
          ),
        ],
      ),
      child: FormBuilder(
        key: LoginCtrl.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '欢迎登录',
              style: SportsTextStyle.baseBold.copyWith(
                fontSize: pt(22),
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: pt(8)),
            Text(
              '请输入您的账号信息',
              style: SportsTextStyle.baseNormal.copyWith(
                fontSize: pt(14),
                color: const Color(0xFF8B8B8B),
              ),
            ),
            SizedBox(height: pt(24)),
            const MobileNumberInput(),
            SizedBox(height: pt(16)),
            SportsPlatform.isAndroid
                ? Listener(
                    onPointerDown: (event) {
                      requestFocusPassword();
                    },
                    child: PasswordInput(
                      focusNode: passwordFocusNode,
                    ),
                  )
                : const PasswordInput(),
          ],
        ),
      ),
    );
  }

  /// 构建登录链接 - 极简文本链接
  Widget _buildLoginOtherLink(String title, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(16)),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: pt(8), vertical: pt(4)),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            title,
            style: SportsTextStyle.baseNormal.copyWith(
              fontSize: pt(15),
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建登录按钮 - 现代渐变按钮
  Widget _buildLoginButton(LoginCtrl ctrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(16)),
      width: double.infinity,
      height: pt(52),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(pt(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: pt(10),
            offset: Offset(0, pt(2)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(pt(20)),
          onTap: widget.state.loginLoading
              ? null
              : () {
                  ctrl.unFocus(context);
                  ctrl.submit();
                },
          child: Center(
            child: widget.state.loginLoading
                ? SizedBox(
                    width: pt(24),
                    height: pt(24),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    '立即登录',
                    style: SportsTextStyle.baseBold.copyWith(
                      fontSize: pt(17),
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  /// 构建错误显示区域 - 扁平化设计
  Widget _buildErrorDisplay() {
    return BlocBuilder<LoginCtrl, LoginState>(
      builder: (context, state) {
        if (state.errorMessage == null || state.errorMessage!.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.only(top: pt(12), left: pt(16), right: pt(16)),
          padding: EdgeInsets.symmetric(horizontal: pt(12), vertical: pt(10)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(pt(12)),
            border: Border.all(
              color: AppColors.error,
              width: pt(1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error,
                size: pt(20),
              ),
              SizedBox(width: pt(10)),
              Expanded(
                child: Text(
                  state.errorMessage!,
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(14),
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<LoginCtrl>().clearError();
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.error,
                  size: pt(18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
