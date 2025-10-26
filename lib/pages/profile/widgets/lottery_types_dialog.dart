import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/app_state.dart';
import 'package:lottery_app/global/commom/lottery_icon.dart';
import 'package:lottery_app/global/model/agent_info_type.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';

/// 显示支持的彩种对话框
void showLotteryTypesDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const LotteryTypesDialog(),
  );
}

class LotteryTypesDialog extends StatelessWidget {
  const LotteryTypesDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(pt(16)),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: EdgeInsets.all(pt(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  color: AppColors.primary,
                  size: pt(24),
                ),
                Gap(pt(12)),
                Expanded(
                  child: Text(
                    '支持的彩种',
                    style: SportsTextStyle.baseBold.copyWith(
                      fontSize: pt(18),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: pt(20),
                  ),
                ),
              ],
            ),
            Gap(pt(20)),
            Flexible(
              child: BlocBuilder<AppController, AppState>(
                builder: (context, state) {
                  final lotteryConfig = state.agentInfo?.lotteryConfig ?? [];
                  
                  if (lotteryConfig.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: pt(48),
                            color: AppColors.textSecondary,
                          ),
                          Gap(pt(16)),
                          Text(
                            '暂无支持的彩种',
                            style: SportsTextStyle.baseNormal.copyWith(
                              fontSize: pt(14),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: lotteryConfig.length,
                    separatorBuilder: (context, index) => Gap(pt(12)),
                    itemBuilder: (context, index) {
                      final config = lotteryConfig[index];
                      return _buildLotteryItem(config);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建彩种项
  Widget _buildLotteryItem(LotteryConfig config) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: pt(16),
        vertical: pt(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(pt(12)),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: pt(1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: pt(40),
            height: pt(40),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(pt(10)),
            ),
            child: Icon(
              getLotteryTypeIcon(config.lotteryType),
              color: AppColors.primary,
              size: pt(20),
            ),
          ),
          Gap(pt(12)),
          Expanded(
            child: Text(
              config.lotteryType.displayName,
              style: SportsTextStyle.baseBold.copyWith(
                fontSize: pt(15),
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '¥${config.unitPrice}/张',
            style: SportsTextStyle.baseBold.copyWith(
              fontSize: pt(15),
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
