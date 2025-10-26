// / 构建现代化操作按钮
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';

Widget buildModernActionButton(
  String title,
  String subtitle,
  IconData icon,
  Color color,
  VoidCallback onTap,
) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(pt(16)),
      child: Container(
        padding: EdgeInsets.all(pt(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(pt(16)),
          border: Border.all(
            color: const Color(0xFFE8E8E8),
            width: pt(1),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: pt(12),
              offset: Offset(0, pt(4)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(pt(10)),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(pt(10)),
                  ),
                  child: Icon(
                    icon,
                    size: pt(20),
                    color: color,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: pt(16),
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            Gap(pt(16)),
            Text(
              title,
              style: SportsTextStyle.baseBold.copyWith(
                fontSize: pt(16),
                color: AppColors.accentBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(pt(4)),
            Text(
              subtitle,
              style: SportsTextStyle.baseNormal.copyWith(
                fontSize: pt(12),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
