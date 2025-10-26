import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/recharge_records/controller.dart';
import 'package:lottery_app/pages/recharge_records/state.dart';
import 'package:lottery_app/pages/recharge_records/widgets/recharge_record_item.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/common/balance_info_card_widget.dart';
import 'package:lottery_app/widgets/common/dropdown_menu.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';
import 'package:lottery_app/widgets/common/pull_refresh_easy.dart';

class RechargeRecordView extends StatelessWidget {
  final RechargeRecordsState state;

  const RechargeRecordView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          const SafeArea(child: SizedBox()),
          Expanded(
            child: PullOrRefreshEasy(
              onRefresh: () async {
                context.read<RechargeRecordsCtrl>().onRefresh();
              },
              onLoading: () async {
                context.read<RechargeRecordsCtrl>().onLoading();
              },
              refreshController:
                  context.read<RechargeRecordsCtrl>().refreshController,
              child: CustomScrollView(
                slivers: [
                  // 用户余额卡片
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(top: pt(16)),
                      // ignore: prefer_const_constructors
                      child: BalanceInfoCardWidget(
                        popHandler: () {
                          context.read<RechargeRecordsCtrl>().loadRecords();
                        },
                      ),
                    ),
                  ),

                  // 充值记录标题栏（吸顶）
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: _RechargeRecordsHeaderDelegate(
                      child: Container(
                        color: const Color(0xFFF8F9FA),
                        padding: EdgeInsets.only(
                          top: pt(20),
                          left: pt(16),
                          right: pt(16),
                          bottom: pt(12),
                        ),
                        child: Column(
                          children: [
                            _buildRechargeRecordsHeader(context),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 充值记录列表
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: pt(16)),
                    sliver: _buildRechargeRecordsList(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建充值记录标题栏
  Widget _buildRechargeRecordsHeader(BuildContext context) {
    return BlocBuilder<RechargeRecordsCtrl, RechargeRecordsState>(
      builder: (context, state) {
        return Row(
          children: [
            Text(
              '充值记录',
              style: TextStyle(
                fontSize: pt(18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            LotteryDropdownMenu<RechargeType>(
              hintText: '选择充值类型',
              width: pt(120),
              items: RechargeType.values
                  .map((RechargeType item) => DropdownMenuItem<RechargeType>(
                        value: item,
                        child: Text(
                          item.displayName,
                          style: TextStyle(
                            color: AppColors.accentBlue,
                            fontSize: pt(14),
                          ),
                        ),
                      ))
                  .toList(),
              value: state.rechargeType,
              onChanged: (RechargeType? value) {
                if (value != null) {
                  context.read<RechargeRecordsCtrl>().selectRechargeType(value);
                }
              },
            ),
            SizedBox(width: pt(12)),
            LotteryDropdownMenu<SortType>(
              hintText: '选择排序方式',
              width: pt(120),
              items: SortType.values
                  .map((SortType item) => DropdownMenuItem<SortType>(
                        value: item,
                        child: Text(
                          item.displayName,
                          style: TextStyle(
                            color: AppColors.accentBlue,
                            fontSize: pt(14),
                          ),
                        ),
                      ))
                  .toList(),
              value: state.sortType,
              onChanged: (SortType? value) {
                if (value != null) {
                  context.read<RechargeRecordsCtrl>().selectSortType(value);
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// 构建充值记录列表
  Widget _buildRechargeRecordsList(BuildContext context) {
    if (state.pageStatus != PageStatus.success) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(top: pt(80)),
          child: LotteryPageLoading(
            status: state.pageStatus,
            child: Container(height: pt(200)),
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final record = state.records[index];
          return Container(
            margin: EdgeInsets.only(bottom: pt(12)),
            child: RechargeRecordItem(record: record),
          );
        },
        childCount: state.records.length,
      ),
    );
  }
}

/// 自定义SliverPersistentHeaderDelegate实现吸顶效果
class _RechargeRecordsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _RechargeRecordsHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => pt(73); // 标题栏的最大高度

  @override
  double get minExtent => pt(73); // 标题栏的最小高度

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
