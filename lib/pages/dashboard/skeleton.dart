import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/common/skeleton_loading.dart';

/// 首页骨架屏
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8FAFF),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SkeletonLoading(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSkeleton(),
                Gap(pt(24)),
                _buildWelcomeCardSkeleton(),
                Gap(pt(24)),
                _buildDataOverviewSkeleton(),
                Gap(pt(24)),
                _buildTrendChartSkeleton(),
                Gap(pt(24)),
                _buildQuickActionsSkeleton(),
                Gap(pt(32)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建顶部Header骨架屏
  Widget _buildHeaderSkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pt(20), vertical: pt(16)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: pt(120), height: pt(24)),
              Gap(pt(4)),
              SkeletonLine(width: pt(180), height: pt(14)),
            ],
          ),
          const Spacer(),
          SkeletonBox(
            width: pt(48),
            height: pt(48),
            borderRadius: pt(12),
          ),
        ],
      ),
    );
  }

  /// 构建欢迎卡片骨架屏
  Widget _buildWelcomeCardSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      padding: EdgeInsets.all(pt(24)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.mediumBlue.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(pt(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: pt(100), height: pt(20)),
                Gap(pt(8)),
                SkeletonLine(width: pt(160), height: pt(14)),
              ],
            ),
          ),
          SkeletonBox(
            width: pt(64),
            height: pt(64),
            borderRadius: pt(12),
          ),
        ],
      ),
    );
  }

  /// 构建数据统计骨架屏
  Widget _buildDataOverviewSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: pt(80), height: pt(20)),
          Gap(pt(16)),
          Row(
            children: [
              Expanded(child: _buildDataCardSkeleton()),
              Gap(pt(12)),
              Expanded(child: _buildDataCardSkeleton()),
            ],
          ),
          Gap(pt(12)),
          _buildDataCardSkeleton(isFullWidth: true),
        ],
      ),
    );
  }

  /// 构建数据卡片骨架屏
  Widget _buildDataCardSkeleton({bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: EdgeInsets.all(pt(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(16)),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: pt(1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(
                width: pt(40),
                height: pt(40),
                borderRadius: pt(10),
              ),
              const Spacer(),
              SkeletonLine(width: pt(40), height: pt(20)),
            ],
          ),
          Gap(pt(16)),
          SkeletonLine(width: pt(60), height: pt(14)),
          Gap(pt(8)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SkeletonLine(width: pt(80), height: pt(28)),
              Gap(pt(4)),
              SkeletonLine(width: pt(20), height: pt(14)),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建趋势图表骨架屏
  Widget _buildTrendChartSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: pt(80), height: pt(20)),
          Gap(pt(16)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(pt(24)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(pt(16)),
              border: Border.all(
                color: const Color(0xFFE8E8E8),
                width: pt(1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonBox(
                      width: pt(40),
                      height: pt(40),
                      borderRadius: pt(8),
                    ),
                    Gap(pt(12)),
                    SkeletonLine(width: pt(120), height: pt(16)),
                  ],
                ),
                Gap(pt(20)),
                SkeletonBox(
                  width: double.infinity,
                  height: pt(120),
                  borderRadius: pt(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建快捷操作骨架屏
  Widget _buildQuickActionsSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: pt(80), height: pt(20)),
          Gap(pt(16)),
          Row(
            children: [
              Expanded(child: _buildActionButtonSkeleton()),
              Gap(pt(12)),
              Expanded(child: _buildActionButtonSkeleton()),
            ],
          ),
          Gap(pt(12)),
          Row(
            children: [
              Expanded(child: _buildActionButtonSkeleton()),
              Gap(pt(12)),
              Expanded(child: _buildActionButtonSkeleton()),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮骨架屏
  Widget _buildActionButtonSkeleton() {
    return Container(
      padding: EdgeInsets.all(pt(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(16)),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: pt(1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(
                width: pt(40),
                height: pt(40),
                borderRadius: pt(10),
              ),
              const Spacer(),
              SkeletonLine(width: pt(16), height: pt(16)),
            ],
          ),
          Gap(pt(16)),
          SkeletonLine(width: pt(60), height: pt(16)),
          Gap(pt(4)),
          SkeletonLine(width: pt(80), height: pt(12)),
        ],
      ),
    );
  }
}
