import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/router/router.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/base/btn.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';
import 'package:lottery_app/widgets/common/sports_app_bar.dart';

import 'model/lottery_package_info.dart';
import 'state.dart';
import 'widgets/package_selector.dart';
import 'controller.dart';

class UnifiedPaymentView extends HookWidget {
  final UnifiedPaymentState state;

  const UnifiedPaymentView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<UnifiedPaymentCtrl>();
    final customAmountController = useTextEditingController();
    final remarkController = useTextEditingController();

    return Scaffold(
      appBar: SportsAppBar(
        title: '支付中心',
        onBack: () {
          BaseRouter.popToRoot();
        },
      ),
      backgroundColor: const Color(0xFFF8FAFF),
      body: LotteryPageLoading(
        status: state.isLoading
            ? PageStatus.loading
            : state.hasError
                ? PageStatus.error
                : PageStatus.success,
        child: _buildContent(
            context, ctrl, customAmountController, remarkController),
      ),
      bottomNavigationBar: _buildFixedPaymentButton(context, ctrl),
    );
  }

  Widget _buildContent(
    BuildContext context,
    UnifiedPaymentCtrl ctrl,
    TextEditingController customAmountController,
    TextEditingController remarkController,
  ) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScrollView(
        slivers: [
          // 账户余额卡片
          // SliverToBoxAdapter(
          //   child: Column(
          //     children: [
          //       _buildAccountBalanceCard(),
          //       Gap(pt(12)),
          //     ],
          //   ),
          // ),
          // 粘性支付类型选择器
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabDelegate(
              ctrl: ctrl,
              buildStickyTab: _buildStickyPaymentTypeSelector,
            ),
          ),
          // 内容区域
          SliverToBoxAdapter(
            child: Column(
              children: [
                Gap(pt(12)),
                if (state.paymentType == PaymentType.Package)
                  _buildPackageSection(ctrl)
                else
                  _buildRechargeSection(ctrl, customAmountController),
                Gap(pt(12)),
                _buildRemarkSection(ctrl, remarkController),
                Gap(pt(32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建粘性支付类型选择器（动态样式）
  Widget _buildStickyPaymentTypeSelector(
      UnifiedPaymentCtrl ctrl, double shrinkOffset) {
    // 根据收缩偏移量判断是否已经开始固定
    final bool isSticking = shrinkOffset > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: pt(64), // 明确设置高度，与委托类一致
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isSticking
            ? BorderRadius.zero
            : BorderRadius.only(
                topLeft: Radius.circular(pt(12)),
                topRight: Radius.circular(pt(12)),
              ),
        border: isSticking
            ? Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: pt(1),
                ),
              )
            : null,
        boxShadow: isSticking
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: pt(4),
                  offset: Offset(0, pt(2)),
                ),
              ],
      ),
      child: _buildTabContent(ctrl),
    );
  }

  /// 构建Tab内容（共用部分）
  Widget _buildTabContent(UnifiedPaymentCtrl ctrl) {
    return Row(
      children: PaymentType.values.map((type) {
        final isSelected = state.paymentType == type;
        return Expanded(
          child: GestureDetector(
            onTap: () => ctrl.switchPaymentType(type),
            child: Container(
              height: pt(64), // 明确设置高度
              decoration: BoxDecoration(
                border: isSelected
                    ? Border(
                        bottom: BorderSide(
                          color: const Color(0xFF667EEA),
                          width: pt(3),
                        ),
                      )
                    : null,
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      type == PaymentType.Package
                          ? Icons.shopping_cart_outlined
                          : Icons.account_balance_wallet_outlined,
                      size: pt(16),
                      color: isSelected
                          ? const Color(0xFF667EEA)
                          : Colors.grey[600],
                    ),
                    Gap(pt(6)),
                    Flexible(
                      child: Text(
                        type.displayName,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: SportsTextStyle.baseBold.copyWith(
                          fontSize: pt(14),
                          color: isSelected
                              ? const Color(0xFF667EEA)
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建套餐选择部分
  Widget _buildPackageSection(UnifiedPaymentCtrl ctrl) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: pt(16)),
      padding: EdgeInsets.all(pt(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(12)),
      ),
      child: PackageSelector(
        packages: state.packages,
        selectedPackage: state.selectedPackage,
        onPackageSelected: ctrl.selectPackage,
      ),
    );
  }

  /// 构建余额充值部分
  Widget _buildRechargeSection(
      UnifiedPaymentCtrl ctrl, TextEditingController controller) {
    final appState = BaseConfig.appContext!.read<AppController>().state;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: pt(16)),
      padding: EdgeInsets.all(pt(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '充值金额',
            style: SportsTextStyle.baseBold.copyWith(
              fontSize: pt(16),
              color: Colors.black,
            ),
          ),
          Gap(pt(16)),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '请输入充值金额',
              labelStyle: SportsTextStyle.baseNormal.copyWith(
                fontSize: pt(14),
                color: Colors.grey[600],
              ),
              hintText: '最低${appState.miniDepositAmount}元',
              prefixText: '¥ ',
              // helperText: ctrl.getMinAmountText(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(pt(8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(pt(8)),
                borderSide: BorderSide(color: Colors.blue, width: pt(2)),
              ),
            ),
            onChanged: (value) {
              double amount = double.tryParse(value) ?? 0.0;
              ctrl.setCustomAmount(amount);
            },
          ),
          if (state.customAmount > 0 && !state.isRechargeAmountValid)
            Padding(
              padding: EdgeInsets.only(top: pt(8)),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: pt(16),
                    color: Colors.red,
                  ),
                  Gap(pt(4)),
                  Text(
                    '金额不能少于¥${appState.miniDepositAmount}',
                    style: SportsTextStyle.baseNormal.copyWith(
                      fontSize: pt(12),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          Gap(pt(16)),
          _buildQuickAmountButtons(ctrl, controller),
        ],
      ),
    );
  }

  /// 获取有效的快捷金额列表
  List<double> _getValidQuickAmounts(double minDepositAmount) {
    /// 预设的快捷金额选项
    const presetAmounts = [100.0, 500.0, 1000.0, 5000.0];

    /// 过滤掉小于最小充值金额的选项，并去重
    final validAmounts = <double>[];
    final seenAmounts = <double>{};

    for (final amount in presetAmounts) {
      if (amount >= minDepositAmount && !seenAmounts.contains(amount)) {
        validAmounts.add(amount);
        seenAmounts.add(amount);
      }
    }

    /// 如果最小充值金额不在预设列表中且大于100，则添加最小充值金额作为选项
    if (!seenAmounts.contains(minDepositAmount) && minDepositAmount > 100) {
      validAmounts.insert(0, minDepositAmount);
    }

    return validAmounts;
  }

  /// 构建快捷金额按钮
  Widget _buildQuickAmountButtons(
      UnifiedPaymentCtrl ctrl, TextEditingController controller) {
    final appState = BaseConfig.appContext!.read<AppController>().state;
    final validAmounts = _getValidQuickAmounts(appState.miniDepositAmount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '快捷金额',
          style: SportsTextStyle.baseNormal.copyWith(
            fontSize: pt(14),
            color: Colors.grey[600],
          ),
        ),
        Gap(pt(8)),
        Wrap(
          spacing: pt(8),
          runSpacing: pt(8),
          children: validAmounts.map((amount) {
            final isSelected = state.customAmount == amount;
            return GestureDetector(
              onTap: () {
                ctrl.setCustomAmount(amount);
                controller.text = amount.toStringAsFixed(0);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: pt(16),
                  vertical: pt(8),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[100],
                  borderRadius: BorderRadius.circular(pt(20)),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  '¥${amount.toStringAsFixed(0)}',
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(12),
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 构建备注部分
  Widget _buildRemarkSection(
    UnifiedPaymentCtrl ctrl,
    TextEditingController controller,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: pt(16)),
      padding: EdgeInsets.all(pt(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '备注信息（可选）',
            style: SportsTextStyle.baseBold.copyWith(
              fontSize: pt(16),
              color: Colors.black,
            ),
          ),
          Gap(pt(16)),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '请输入备注信息',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(pt(8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(pt(8)),
                borderSide: BorderSide(color: Colors.blue, width: pt(2)),
              ),
            ),
            onChanged: ctrl.setRemark,
          ),
        ],
      ),
    );
  }

  /// 构建固定在底部的支付按钮
  Widget _buildFixedPaymentButton(
      BuildContext context, UnifiedPaymentCtrl ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: pt(8),
            offset: Offset(0, -pt(2)),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(pt(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.paymentAmount > 0) _buildPaymentSummary(),
              _buildActionButton(context, ctrl),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建支付汇总信息
  Widget _buildPaymentSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(pt(12)),
      margin: EdgeInsets.only(bottom: pt(12)),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(pt(8)),
      ),
      child: Column(
        children: [
          if (state.paymentType == PaymentType.Package &&
              state.selectedPackage != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '选择套餐',
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(14),
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  _getPackageName(state.selectedPackage!),
                  style: SportsTextStyle.baseBold.copyWith(
                    fontSize: pt(14),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            Gap(pt(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '包含张数',
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(14),
                    color: Colors.grey[600],
                  ),
                ),
                Gap(pt(8)),
                Expanded(
                  child: Text(
                    _getPackageQuantity(state.selectedPackage!),
                    style: SportsTextStyle.baseBold.copyWith(
                      fontSize: pt(14),
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.right,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            Gap(pt(8)),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                state.paymentType == PaymentType.Balance ? '充值金额' : '应付金额',
                style: SportsTextStyle.baseNormal.copyWith(
                  fontSize: pt(16),
                  color: Colors.blue,
                ),
              ),
              Text(
                '¥${state.paymentAmount.toStringAsFixed(2)}',
                style: SportsTextStyle.baseBold.copyWith(
                  fontSize: pt(20),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(BuildContext context, UnifiedPaymentCtrl ctrl) {
    return SportsBtn(
      text: state.isProcessing
          ? '处理中...'
          : state.paymentType == PaymentType.Balance
              ? '立即充值'
              : '立即购买',
      width: double.infinity,
      height: pt(48),
      btnLoading: state.isProcessing,
      disabled: state.isProcessing || state.isLoading,
      tapHandle: () => ctrl.initiatePayment(context),
    );
  }

  /// 获取套餐名称
  String _getPackageName(LotteryPackageInfo package) {
    final lotteryType = LotteryType.fromValue(int.parse(package.lotteryType!));
    return '${lotteryType.displayName}套餐';
  }

  String _getPackageQuantity(LotteryPackageInfo package) {
    final lotteryType = LotteryType.fromValue(int.parse(package.lotteryType!));
    if (package.bonusQuantity != null &&
        int.parse(package.bonusQuantity!) > 0) {
      return '${package.minQuantity}张${lotteryType.displayName}+赠${package.bonusQuantity}张${lotteryType.displayName}';
    } else {
      return '${package.minQuantity}张${lotteryType.displayName}套餐';
    }
  }
}

/// 粘性Tab的委托类
class _StickyTabDelegate extends SliverPersistentHeaderDelegate {
  final UnifiedPaymentCtrl ctrl;
  final Widget Function(UnifiedPaymentCtrl, double) buildStickyTab;

  const _StickyTabDelegate({
    required this.ctrl,
    required this.buildStickyTab,
  });

  @override
  double get minExtent => 64.0; // 最小高度

  @override
  double get maxExtent => 64.0; // 最大高度

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return buildStickyTab(ctrl, shrinkOffset);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
