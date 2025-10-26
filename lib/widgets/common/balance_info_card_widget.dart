// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/app_state.dart';
import 'package:lottery_app/global/commom/lottery_icon.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/router/router.dart';
import 'package:lottery_app/router/routes.dart';
import 'package:lottery_app/utils/pt.dart';

/** 余额信息卡片组件 */
class BalanceInfoCardWidget extends StatefulWidget {
  final void Function()? popHandler;

  const BalanceInfoCardWidget({
    Key? key,
    this.popHandler,
  }) : super(key: key);

  @override
  State<BalanceInfoCardWidget> createState() => _BalanceInfoCardWidgetState();
}

class _BalanceInfoCardWidgetState extends State<BalanceInfoCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool _updating = false;

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

  /** 更新余额 */
  Future<void> _updateBalance() async {
    setState(() {
      _updating = true;
    });

    _rotationController.repeat();

    await BaseConfig.appContext!.read<AppController>().fetchAgentInfo();

    _rotationController.stop();

    setState(() {
      _updating = false;
    });
  }

  /** 获取有效的套餐列表（余额大于0且彩票类型启用） */
  List<MapEntry<String, dynamic>> _getValidPackageList(
      Map<String, dynamic>? packageBalance) {
    if (packageBalance == null || packageBalance.isEmpty) {
      return [];
    }

    return packageBalance.entries
        .where((entry) => entry.value > 0)
        .where((entry) {
      // 检查是否有对应的启用的彩票类型
      try {
        LotteryType.values.firstWhere(
          (type) => type.value.toString() == entry.key && type.enable,
        );
        return true;
      } catch (_) {
        return false;
      }
    }).toList();
  }

  /** 判断是否显示套餐信息部分 */
  bool _shouldShowPackageInfo(
    List<MapEntry<String, dynamic>> validPackageList,
  ) {
    return validPackageList.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppController, AppState>(
      builder: (context, state) {
        final agentInfo = state.agentInfo;
        final packageBalance = agentInfo?.packageBalance;
        final validPackageList = _getValidPackageList(packageBalance);

        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: pt(20)),
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
            children: [
              // 余额部分
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: pt(16),
                  vertical: pt(12),
                ),
                decoration: BoxDecoration(
                  border: _shouldShowPackageInfo(validPackageList)
                      ? Border(
                          bottom: BorderSide(
                            color: const Color(0xFFE8E8E8),
                            width: pt(1),
                          ),
                        )
                      : null,
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
                        Icons.account_balance_wallet,
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
                                '账户余额',
                                style: SportsTextStyle.baseNormal.copyWith(
                                  fontSize: pt(14),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Gap(pt(8)),
                              GestureDetector(
                                onTap: _updateBalance,
                                child: RotationTransition(
                                  turns: _rotationController,
                                  child: Icon(
                                    Icons.refresh,
                                    color: _updating
                                        ? AppColors.primary
                                        : AppColors.success,
                                    size: pt(18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(pt(4)),
                          Text(
                            '¥${agentInfo?.balance ?? '0.00'}',
                            style: SportsTextStyle.baseBold.copyWith(
                              fontSize: pt(20),
                              color: AppColors.primary,
                              fontFamily: 'PingFang SC',
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await BaseRouter.push(
                            url: AppPage.unifiedPaymentPage.path);
                        BaseConfig.appContext!
                            .read<AppController>()
                            .fetchAgentInfo();
                        widget.popHandler?.call();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: pt(12),
                          vertical: pt(6),
                        ),
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
                            Text(
                              '立即充值',
                              style: SportsTextStyle.baseBold.copyWith(
                                fontSize: pt(12),
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 套餐信息部分 - 只显示余额大于0的套餐
              if (_shouldShowPackageInfo(validPackageList))
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: pt(16), vertical: pt(8)),
                  child: Column(
                    children: validPackageList.map((entry) {
                      // 根据key查找对应的LotteryType
                      final lotteryType = LotteryType.values.firstWhere(
                        (type) =>
                            type.value.toString() == entry.key && type.enable,
                      );
                      return _buildPackageItem(lotteryType, entry.value);
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /** 构建套餐项 */
  Widget _buildPackageItem(LotteryType lotteryType, dynamic balance) {
    final int balanceValue = balance is int ? balance : 0;
    return Container(
      padding: EdgeInsets.symmetric(vertical: pt(8)),
      child: Row(
        children: [
          Icon(
            getLotteryTypeIcon(lotteryType),
            color: AppColors.primary,
            size: pt(16),
          ),
          Gap(pt(8)),
          Text(
            lotteryType.displayName,
            style: SportsTextStyle.baseNormal.copyWith(
              fontSize: pt(14),
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            '$balanceValue张',
            style: SportsTextStyle.baseBold.copyWith(
              fontSize: pt(14),
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
