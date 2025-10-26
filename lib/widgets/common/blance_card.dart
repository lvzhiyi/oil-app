import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/app_state.dart';
import 'package:lottery_app/global/commom/lottery_icon.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/router/router.dart';
import 'package:lottery_app/router/routes.dart';
import 'package:lottery_app/utils/pt.dart';

class BlanceCard extends StatefulWidget {
  const BlanceCard({super.key});

  @override
  State<BlanceCard> createState() => _BlanceCardState();
}

class _BlanceCardState extends State<BlanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool updating = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  updateBalance() async {
    setState(() {
      updating = true;
    });

    // 开始旋转动画
    _rotationController.repeat();

    await BaseConfig.appContext!.read<AppController>().fetchAgentInfo();

    // 停止旋转动画
    _rotationController.stop();

    setState(() {
      updating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(pt(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: pt(12),
            offset: Offset(0, pt(4)),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 左侧图标区域
              Container(
                width: pt(60),
                height: pt(60),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(pt(16)),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.primary,
                  size: pt(28),
                ),
              ),
              SizedBox(width: pt(8)),
              // 右侧信息区域
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '账户余额',
                          style: TextStyle(
                            fontSize: pt(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: pt(8)),
                        GestureDetector(
                          onTap: () => {
                            updateBalance(),
                          },
                          child: RotationTransition(
                            turns: _rotationController,
                            child: Icon(
                              Icons.refresh,
                              color: updating
                                  ? AppColors.primary
                                  : AppColors.success,
                              size: pt(22),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: pt(4)),
                    BlocBuilder<AppController, AppState>(
                      builder: (context, state) {
                        return Text(
                          '¥${state.agentInfo?.balance}',
                          style: TextStyle(
                            fontSize: pt(28),
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            fontFamily: 'PingFang SC',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // 右侧充值按钮
              GestureDetector(
                onTap: () => {
                  BaseRouter.push(url: AppPage.unifiedPaymentPage.path),
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: pt(12), vertical: pt(6)),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(pt(20)),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                      width: pt(1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: pt(6),
                        height: pt(6),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: pt(6)),
                      Text(
                        '去充值',
                        style: TextStyle(
                          fontSize: pt(12),
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: pt(20)),
          Divider(
            color: AppColors.textSecondary.withValues(alpha: 0.3),
            height: pt(1),
            thickness: pt(1),
          ),
          SizedBox(height: pt(20)),
          _buildPackageInfoCard(),
        ],
      ),
    );
  }

  /// 构建套餐信息卡片
  Widget _buildPackageInfoCard() {
    final packageBalance = BaseConfig.appContext!
        .read<AppController>()
        .state
        .agentInfo
        ?.packageBalance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: pt(32),
              height: pt(32),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(pt(8)),
              ),
              child: Icon(
                Icons.category,
                color: AppColors.primary,
                size: pt(18),
              ),
            ),
            SizedBox(width: pt(12)),
            Text(
              '套餐信息',
              style: TextStyle(
                fontSize: pt(18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: pt(20)),
        // 套餐信息网格
        Wrap(
          spacing: pt(16),
          children: LotteryType.values.map((lotteryType) {
            if (!lotteryType.enable) {
              return const SizedBox.shrink();
            }
            final balance = packageBalance?[lotteryType.value.toString()] ?? 0;

            return Container(
              width: pt(360),
              padding: EdgeInsets.all(pt(16)),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(pt(12)),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  width: pt(1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        getLotteryTypeIcon(lotteryType),
                        color: AppColors.primary,
                        size: pt(20),
                      ),
                      SizedBox(width: pt(8)),
                      Text(
                        lotteryType.displayName,
                        style: TextStyle(
                          fontSize: pt(16),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: pt(12)),
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.textSecondary,
                        size: pt(16),
                      ),
                      SizedBox(width: pt(6)),
                      Text(
                        '剩余张数',
                        style: TextStyle(
                          fontSize: pt(12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$balance张',
                        style: TextStyle(
                          fontSize: pt(14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
