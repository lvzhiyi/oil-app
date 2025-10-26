// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';
import '../model/rest_employee_response_data.dart';

class NewPasswordInfoDialog extends StatelessWidget {
  /** 用户资料信息 */
  final RestEmployeeResponseData? data;

  const NewPasswordInfoDialog({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: pt(20), vertical: pt(12)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: pt(12)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: const Color(0xFFE8E8E8), width: pt(1)),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '手机号',
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
                        data?.phone ?? '-',
                        style: SportsTextStyle.baseNormal.copyWith(
                          fontSize: pt(11),
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(pt(12)),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Text(
                      '新密码',
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
                        data?.password ?? '-',
                        style: SportsTextStyle.baseNormal.copyWith(
                          fontSize: pt(11),
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gap(pt(30)),
      ],
    );
  }
}
