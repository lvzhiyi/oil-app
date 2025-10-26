import 'package:flutter/material.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';

/// 卡片式区块容器
class SectionCard extends StatelessWidget {
  /// 标题文本
  final String title;

  /// 标题右侧操作区域
  final Widget? trailing;

  /// 标题区域内边距
  final EdgeInsets? headerPadding;

  /// 内容区域内边距
  final EdgeInsets? contentPadding;

  /// 区块内容
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.title,
    this.trailing,
    this.headerPadding,
    this.contentPadding,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: headerPadding ?? EdgeInsets.all(pt(20)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: SportsTextStyle.baseBold.copyWith(
                      fontSize: pt(16),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: contentPadding ?? EdgeInsets.all(pt(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
