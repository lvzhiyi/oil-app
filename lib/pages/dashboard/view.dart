import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/pages/dashboard/controller.dart';
import 'package:lottery_app/pages/dashboard/skeleton.dart';
import 'package:lottery_app/pages/dashboard/state.dart';
import 'package:lottery_app/pages/dashboard/widgets/line_chart.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';
import 'package:lottery_app/widgets/common/pull_refresh_easy.dart';

class DashboardView extends HookWidget {
  final DashboardState state;

  const DashboardView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 只有首次加载且正在加载时才显示骨架屏
    if (state.isFirstLoad && state.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFF),
        body: DashboardSkeleton(),
      );
    }

    // 如果有错误，显示错误页面
    if (state.hasError) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFF),
        body: LotteryPageLoading(
          status: PageStatus.error,
          child: Container(),
        ),
      );
    }

    // 正常显示内容（包括后续的loading状态）
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: _buildDashboardContent(context),
    );
  }

  /// 构建仪表盘内容
  Widget _buildDashboardContent(BuildContext context) {
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
        child: PullOrRefreshEasy(
          refreshController: context.read<DashboardCtrl>().refreshController,
          onRefresh: () async {
            context.read<DashboardCtrl>().loadDashboardData();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Gap(pt(24)),
                _buildDataOverview(),
                Gap(pt(24)),
                _buildTrendChart(),
                Gap(pt(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建顶部header
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pt(20), vertical: pt(16)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '闪省赠彩',
                style: SportsTextStyle.baseBold.copyWith(
                  fontSize: pt(24),
                  color: AppColors.accentBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gap(pt(4)),
              Text(
                '欢迎回来，今天是美好的一天',
                style: SportsTextStyle.baseNormal.copyWith(
                  fontSize: pt(14),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              // 非首次加载时显示loading指示器
              if (!state.isFirstLoad && state.isLoading)
                Container(
                  margin: EdgeInsets.only(right: pt(12)),
                  child: SizedBox(
                    width: pt(16),
                    height: pt(16),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建数据看板
  Widget _buildDataOverview() {
    // 如果是非首次加载且正在loading，显示带loading的数据卡片
    if (state.accountStats == null) {
      return const SizedBox();
    }

    final stats = state.accountStats!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '数据统计',
            style: SportsTextStyle.baseBold.copyWith(
              fontSize: pt(20),
              color: AppColors.accentBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(pt(16)),
          Row(
            children: [
              Expanded(
                child: _buildModernDataCard(
                  '今日赠送',
                  '${stats.todayGiftCount}',
                  '张',
                  Icons.card_giftcard_outlined,
                  AppColors.primary,
                ),
              ),
              Gap(pt(12)),
              Expanded(
                child: _buildModernDataCard(
                  '累计赠送',
                  '${stats.cumulativeGiftCount}',
                  '张',
                  Icons.redeem_outlined,
                  AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建现代化数据卡片
  Widget _buildModernDataCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color, {
    bool isFullWidth = false,
  }) {
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
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: pt(16),
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
                  color: color,
                  size: pt(20),
                ),
              ),
              const Spacer(),
              // Container(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: pt(8),
              //     vertical: pt(4),
              //   ),
              //   decoration: BoxDecoration(
              //     color: color.withValues(alpha: 0.1),
              //     borderRadius: BorderRadius.circular(pt(6)),
              //   ),
              //   child: Text(
              //     '今日',
              //     style: SportsTextStyle.baseNormal.copyWith(
              //       fontSize: pt(10),
              //       color: color,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
          ),
          Gap(pt(16)),
          Text(
            title,
            style: SportsTextStyle.baseNormal.copyWith(
              fontSize: pt(14),
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gap(pt(8)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: SportsTextStyle.baseBold.copyWith(
                  fontSize: pt(28),
                  color: AppColors.accentBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gap(pt(4)),
              Text(
                unit,
                style: SportsTextStyle.baseNormal.copyWith(
                  fontSize: pt(14),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建趋势图表
  Widget _buildTrendChart() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '赠送走势',
            style: SportsTextStyle.baseBold.copyWith(
              fontSize: pt(20),
              color: AppColors.accentBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
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
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  blurRadius: pt(20),
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
                      padding: EdgeInsets.all(pt(8)),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(pt(8)),
                      ),
                      child: Icon(
                        Icons.trending_up,
                        color: AppColors.primary,
                        size: pt(20),
                      ),
                    ),
                    Gap(pt(12)),
                    Text(
                      '最近7日数据趋势',
                      style: SportsTextStyle.baseBold.copyWith(
                        fontSize: pt(16),
                        color: AppColors.accentBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Gap(pt(20)),
                _buildSimpleLineChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建简单折线图
  Widget _buildSimpleLineChart() {
    if (state.recentGiftTrend.isEmpty) {
      return Container(
        height: pt(200),
        alignment: Alignment.center,
        child: Text(
          '暂无数据',
          style: SportsTextStyle.grayNormal.copyWith(fontSize: pt(14)),
        ),
      );
    }

    // 计算最大值用于缩放
    int maxValue = state.recentGiftTrend
        .map((e) => e.count)
        .reduce((a, b) => a > b ? a : b);
    double chartHeight = pt(150);

    return SizedBox(
      height: chartHeight + pt(40), // 额外空间给标签
      child: Column(
        children: [
          // 图表区域
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: CustomPaint(
                painter: LineChartPainter(
                  data: state.recentGiftTrend,
                  maxValue: maxValue,
                ),
              ),
            ),
          ),
          Gap(pt(8)),
          // X轴标签
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: state.recentGiftTrend.map((record) {
              return Text(
                record.date,
                style: SportsTextStyle.baseNormal.copyWith(
                  fontSize: pt(10),
                  color: Colors.grey[600],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
