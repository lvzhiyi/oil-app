import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/login/state.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

/// Tab导航组件
class TabNavigation extends StatelessWidget {
  final LoginTabType activeTab;
  final Function(LoginTabType) onTabChanged;

  const TabNavigation({
    required this.activeTab,
    required this.onTabChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabItem(
          context,
          '账号登录',
          LoginTabType.password,
        ),
        SizedBox(width: AppSizes.setWidth(32)),
        _buildTabItem(
          context,
          '验证码登录',
          LoginTabType.verification,
        ),
      ],
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    String label,
    LoginTabType tabType,
  ) {
    final isActive = activeTab == tabType;

    return GestureDetector(
      onTap: () => onTabChanged(tabType),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.setFontSize(isActive ? 18 : 16),
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color:
                  isActive ? const Color(0xFF1F2937) : const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: AppSizes.setHeight(8)),
          // 底部指示器
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? AppSizes.setWidth(20) : 0,
            height: AppSizes.setHeight(3),
            decoration: BoxDecoration(
              color: const Color(0xFF7165E3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
