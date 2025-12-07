import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_business_app/pages/change_password/controller.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';

import '../../../utils/sizer_utils.dart';
import '../../../widgets/base/button/common_button.dart';
import '../../../widgets/base/text/common_text.dart';

class _PasswordFieldContainer extends StatefulWidget {
  final FocusNode focusNode;
  final Widget child;

  const _PasswordFieldContainer({
    required this.focusNode,
    required this.child,
  });

  @override
  State<_PasswordFieldContainer> createState() =>
      _PasswordFieldContainerState();
}

class _PasswordFieldContainerState extends State<_PasswordFieldContainer> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isFocused = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(10)),
        border: Border.all(
          color: _isFocused ? CustomAppColor.of(context).primaryColor : CustomAppColor.of(context).containerBorder,
          width: 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: CustomAppColor.of(context).primaryColor.withValues(alpha: 0.1),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(16),
        vertical: AppSizes.setHeight(12),
      ),
      child: widget.child,
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen());
  }

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ChangePasswordCtrl>();
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        bottom: true,
        top: false,
        child: Column(
          children: [
            _buildNavBar(context, statusBarHeight),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.setWidth(16),
                  vertical: AppSizes.setHeight(20),
                ),
                child: FormBuilder(
                  key: ctrl.formKey,
                  child: _buildFormCard(context, ctrl),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, double statusBarHeight) {
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Container(
        height: AppSizes.setHeight(44),
        padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => BaseRouter.pop(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.setWidth(8)),
                  child: Icon(
                    Icons.arrow_back,
                    size: AppSizes.setFontSize(24),
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
            ),
            Center(
              child: CommonText(
                text: '修改密码',
                fontSize: AppSizes.setFontSize(17),
                fontWeight: FontWeight.w600,
                textColor: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, ChangePasswordCtrl ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.02),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(20),
        vertical: AppSizes.setHeight(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBrandArea(),
          SizedBox(height: AppSizes.setHeight(32)),
          _buildAccountField(context, ctrl),
          SizedBox(height: AppSizes.setHeight(20)),
          _buildPasswordField(
            context,
            ctrl,
            'password',
            '新密码',
            '8-20位，含字母和数字',
            _obscureNewPassword,
            _newPasswordFocusNode,
            (value) {
              setState(() {
                _obscureNewPassword = value;
              });
            },
          ),
          SizedBox(height: AppSizes.setHeight(20)),
          _buildPasswordField(
            context,
            ctrl,
            'confirmPassword',
            '确认新密码',
            '请再次输入',
            _obscureConfirmPassword,
            _confirmPasswordFocusNode,
            (value) {
              setState(() {
                _obscureConfirmPassword = value;
              });
            },
          ),
          SizedBox(height: AppSizes.setHeight(12)),
          _buildPasswordRules(),
          SizedBox(height: AppSizes.setHeight(24)),
          _buildSubmitButton(context, ctrl),
        ],
      ),
    );
  }

  Widget _buildBrandArea() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(height: AppSizes.setHeight(8)),
          Container(
            width: AppSizes.setWidth(56),
            height: AppSizes.setHeight(56),
            decoration: BoxDecoration(
              color: CustomAppColor.of(context).bgPrimaryLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgAsset(
                assetName: AssetsSvg.LOCK,
                width: AppSizes.setWidth(28),
                height: AppSizes.setHeight(28),
                color: CustomAppColor.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: AppSizes.setHeight(12)),
          CommonText(
            text: '定期修改密码可有效保护账号资产安全',
            fontSize: AppSizes.setFontSize(13),
            textColor: const Color(0xFF6B7280),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountField(BuildContext context, ChangePasswordCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: '当前账号',
          fontSize: AppSizes.setFontSize(14),
          fontWeight: FontWeight.w600,
          textColor: const Color(0xFF1F2937),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: AppSizes.setHeight(8)),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(AppSizes.setWidth(10)),
            border: Border.all(
              color: Colors.transparent,
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.setWidth(16),
            vertical: AppSizes.setHeight(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: CommonText(
                  text: ctrl.phoneController.text.isEmpty
                      ? '手机号'
                      : _formatPhoneNumber(ctrl.phoneController.text),
                  fontSize: AppSizes.setFontSize(16),
                  fontWeight: FontWeight.w500,
                  textColor: const Color(0xFF1F2937).withValues(alpha: 0.8),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.setWidth(6),
                  vertical: AppSizes.setHeight(2),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(AppSizes.setWidth(4)),
                ),
                child: CommonText(
                  text: '不可修改',
                  fontSize: AppSizes.setFontSize(11),
                  textColor: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    ChangePasswordCtrl ctrl,
    String fieldName,
    String label,
    String hint,
    bool obscureText,
    FocusNode focusNode,
    ValueChanged<bool> onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: label,
          fontSize: AppSizes.setFontSize(14),
          fontWeight: FontWeight.w600,
          textColor: const Color(0xFF1F2937),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: AppSizes.setHeight(8)),
        _PasswordFieldContainer(
          focusNode: focusNode,
          child: Row(
            children: [
              SvgAsset(
                assetName: AssetsSvg.LOCK,
                width: AppSizes.setWidth(18),
                height: AppSizes.setHeight(18),
                color: const Color(0xFF6B7280),
              ),
              SizedBox(width: AppSizes.setWidth(12)),
              Expanded(
                child: FormBuilderTextField(
                  name: fieldName,
                  focusNode: focusNode,
                  obscureText: obscureText,
                  style: TextStyle(
                    fontSize: AppSizes.setFontSize(16),
                    color: const Color(0xFF1F2937),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: AppSizes.setFontSize(15),
                    ),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  validator: fieldName == 'password'
                      ? FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: '请输入新密码'),
                        ])
                      : FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: '请输入确认密码'),
                          (value) {
                            final formState = ctrl.formKey.currentState;
                            final pw = formState?.fields['password']?.value;
                            if (value != pw) {
                              return '密码不一致';
                            }
                            return null;
                          },
                        ]),
                ),
              ),
              GestureDetector(
                onTap: () => onToggle(!obscureText),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(AppSizes.setWidth(4)),
                  child: SvgAsset(
                    assetName: obscureText
                        ? AssetsSvg.EYE_CLOSE_ICON
                        : AssetsSvg.EYE_FILL_ICON,
                    width: AppSizes.setWidth(20),
                    height: AppSizes.setHeight(20),
                    color: obscureText
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF7165E3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRules() {
    return Padding(
      padding: EdgeInsets.only(left: AppSizes.setWidth(4)),
      child: Row(
        children: [
          Container(
            width: AppSizes.setWidth(4),
            height: AppSizes.setHeight(4),
            decoration: const BoxDecoration(
              color: Color(0xFFD1D5DB),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppSizes.setWidth(4)),
          CommonText(
            text: '密码强度检测: 安全',
            fontSize: AppSizes.setFontSize(12),
            textColor: const Color(0xFF6B7280),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, ChangePasswordCtrl ctrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.setWidth(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7165E3).withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: CommonButton(
        isLoading: ctrl.state.loading,
        btnText: '提交修改',
        radius: AppSizes.setWidth(24),
        height: AppSizes.setHeight(56),
        fontSize: AppSizes.setFontSize(16),
        onTap: () {
          ctrl.goToOtpPage();
        },
      ),
    );
  }

  String _formatPhoneNumber(String phone) {
    if (phone.length == 11) {
      return '${phone.substring(0, 3)} ${phone.substring(3, 7)} ${phone.substring(7)}';
    }
    return phone;
  }
}
