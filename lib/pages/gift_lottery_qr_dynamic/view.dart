import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/global/commom/lottery_icon.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/gift_lottery_qr_dynamic/controller.dart';
import 'package:lottery_app/pages/gift_lottery_qr_dynamic/state.dart';
import 'package:lottery_app/pages/gift_lottery_qr_dynamic/widgets/qr_code_display.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/common/base_appbar.dart';

class GiftLotteryQrDynamicView extends StatelessWidget {
  final GiftLotteryQrDynamicState state;

  const GiftLotteryQrDynamicView({Key? key, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const BaseAppBar(
        title: '动态码赠送',
      ),
      body: SafeArea(
        child: _buildContent(context),
      ),
    );
  }

  /// 构建主要内容
  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(pt(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 彩票类型选择
          _buildLotteryTypeSelector(context),

          SizedBox(height: pt(16)),

          /// 生成设置和按钮
          if (state.dynamicQrCode == null) _buildGenerateSection(context),

          SizedBox(height: pt(16)),

          /// 二维码展示区域
          _buildDynamicQrSection(context),
        ],
      ),
    );
  }

  /// 构建彩票类型选择器
  Widget _buildLotteryTypeSelector(BuildContext context) {
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
                '赠送彩票类型',
                style: TextStyle(
                  fontSize: pt(18),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: pt(20)),
          // 彩票类型选择器，显示剩余张数和单价
          Wrap(
            spacing: pt(16),
            runSpacing: pt(16),
            children: LotteryType.values.map((type) {
              final isSelected = state.selectedLotteryType == type;
              return GestureDetector(
                onTap: () {
                  if (type.enable) {
                    context
                        .read<GiftLotteryQrDynamicCtrl>()
                        .selectLotteryType(type);
                  }
                },
                child: Container(
                  width: pt(140),
                  padding: EdgeInsets.symmetric(
                      horizontal: pt(12), vertical: pt(12)),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : type.enable
                            ? Colors.white
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(pt(16)),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : Colors.grey.shade200,
                      width: isSelected ? pt(2) : pt(1),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: pt(12),
                              offset: Offset(0, pt(4)),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: pt(8),
                              offset: Offset(0, pt(2)),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 彩票类型名称
                      Row(
                        children: [
                          Container(
                            width: pt(40),
                            height: pt(40),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(pt(12)),
                            ),
                            child: Icon(
                              getLotteryTypeIcon(type),
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textGray2,
                              size: pt(20),
                            ),
                          ),
                          SizedBox(width: pt(12)),
                          Expanded(
                            child: Text(
                              type.displayName,
                              style: TextStyle(
                                fontSize: pt(16),
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textGray2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 构建生成按钮
  Widget _buildGenerateSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(pt(16)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: pt(40),
                height: pt(40),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(pt(12)),
                ),
                child: Icon(
                  Icons.qr_code,
                  color: AppColors.primary,
                  size: pt(20),
                ),
              ),
              SizedBox(width: pt(12)),
              Text(
                '生成动态二维码',
                style: TextStyle(
                  fontSize: pt(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: pt(20)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context
                    .read<GiftLotteryQrDynamicCtrl>()
                    .generateDynamicQrCode();
              },
              icon: Icon(Icons.qr_code_2, size: pt(18)),
              label: Text(
                '生成动态二维码',
                style: TextStyle(fontSize: pt(16)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: pt(12)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(pt(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建动态二维码区域
  Widget _buildDynamicQrSection(BuildContext context) {
    if (state.dynamicQrCode == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '动态二维码',
              style: TextStyle(
                fontSize: pt(18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: pt(12)),
        QrCodeDisplay(
          qrCode: state.dynamicQrCode!,
          isExpired: state.isExpired,
          isGenerating: state.isGenerating,
          dynamicRefreshCountdown: state.dynamicRefreshCountdown,
          showActions: false,
          onRefresh: () {
            context.read<GiftLotteryQrDynamicCtrl>().generateDynamicQrCode();
          },
          onShare: () {},
          onSave: () {},
        ),
      ],
    );
  }
}
