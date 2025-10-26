// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/app_state.dart';
import 'package:lottery_app/global/model/user_profile_type.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';

class EmployeeInfoCard extends StatelessWidget {
  /** 用户资料信息 */
  final UserProfile? userProfile;

  const EmployeeInfoCard({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppController, AppState>(
      builder: (context, state) {
        final currentEmployee = state.currentEmployee;
        if (currentEmployee == null) return const SizedBox();

        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: pt(20)),
          padding: EdgeInsets.symmetric(horizontal: pt(16), vertical: pt(12)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(pt(16)),
            border: Border.all(
              color: const Color(0xFFE8E8E8),
              width: pt(1),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: pt(16),
                offset: Offset(0, pt(4)),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: pt(48),
                height: pt(48),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(pt(12)),
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: pt(24),
                ),
              ),
              Gap(pt(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          currentEmployee.username ?? '未知员工',
                          style: SportsTextStyle.baseBold.copyWith(
                            fontSize: pt(16),
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Gap(pt(8)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: pt(8),
                            vertical: pt(2),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(pt(10)),
                          ),
                          child: Text(
                            userProfile?.role.displayName ?? '员工',
                            style: SportsTextStyle.baseNormal.copyWith(
                              fontSize: pt(11),
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(pt(6)),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: pt(14),
                          color: AppColors.textSecondary,
                        ),
                        Gap(pt(4)),
                        Text(
                          currentEmployee.phone ?? '未设置',
                          style: SportsTextStyle.baseNormal.copyWith(
                            fontSize: pt(14),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
