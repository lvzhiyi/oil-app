import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottery_app/pages/gift_records/controller.dart';

import 'package:lottery_app/pages/gift_records/model/gift_records_response.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/gift_records/state.dart';
import 'package:lottery_app/pages/gift_records/widgets/gift_record_item.dart';

import 'package:lottery_app/pages/gift_records/widgets/records_stats_card.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';
import 'package:lottery_app/widgets/common/sports_app_bar.dart';
import 'package:lottery_app/widgets/popup/toast.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/common/pull_refresh_easy.dart';

class GiftRecordsView extends StatefulWidget {
  final GiftRecordsState state;

  const GiftRecordsView({Key? key, required this.state}) : super(key: key);

  @override
  State<GiftRecordsView> createState() => _GiftRecordsViewState();
}

class _GiftRecordsViewState extends State<GiftRecordsView> {
  GiftRecordsState get state => widget.state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SportsAppBar(
        title: '赠送记录',
        actions: [
          _buildSortButton(context),
        ],
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body: _buildContent(context),
      // 确保底部安全区域处理
      resizeToAvoidBottomInset: false,
    );
  }

  /// 构建主要内容
  Widget _buildContent(BuildContext context) {
    final ctrl = context.read<GiftRecordsCtrl>();
    return SafeArea(
      bottom: true,
      child: LotteryPageLoading(
        status: state.pageStatus,
        child: PullOrRefreshEasy(
          refreshController: ctrl.refreshController,
          onRefresh: () => ctrl.onRefresh(),
          onLoading: () => ctrl.onLoading(),
          enablePullUp: true,
          noDataText: '暂无更多记录',
          child: CustomScrollView(
            slivers: [
              /// 统计信息卡片
              if (state.stats != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(pt(16)),
                    child: RecordsStatsCard(stats: state.stats!),
                  ),
                ),

              /// 记录列表
              SliverPadding(
                padding: EdgeInsets.only(
                  top: pt(4),
                  bottom: pt(24), // 增加底部间距
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final record = state.records[index];
                      return GiftRecordItemWidget(
                        recordData: record,
                        onTap: () => _showRecordDetail(context, record),
                      );
                    },
                    childCount: state.records.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示记录详情
  void _showRecordDetail(BuildContext context, GiftRecordItem record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildRecordDetailSheet(context, record),
    );
  }

  /// 构建记录详情底部弹窗
  Widget _buildRecordDetailSheet(BuildContext context, GiftRecordItem record) {
    return Container(
      margin: EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 标题栏
          Container(
            padding: EdgeInsets.all(pt(16)),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '记录详情',
                  style: TextStyle(
                    fontSize: pt(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          /// 详情内容
          Padding(
            padding: EdgeInsets.all(pt(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 基本信息卡片
                _buildDetailCard('基本信息', [
                  _buildDetailRow(Icons.tag, '记录ID', record.id.toString()),
                  _buildDetailRow(Icons.access_time, '创建时间',
                      _formatDetailDateTime(record.createTime)),
                  _buildDetailRow(
                      Icons.person, '操作员工', record.creator?.username ?? '未知'),
                ]),

                SizedBox(height: pt(16)),

                /// 生成信息卡片
                _buildDetailCard('生成信息', [
                  _buildDetailRow(Icons.auto_awesome, '生成方式',
                      _getGenerateTypeText(record.type)),
                  _buildDetailRow(Icons.casino, '彩票类型',
                      _getLotteryTypeName(record.lotteryType)),
                  _buildDetailRow(Icons.numbers, '生成数量', record.num ?? '0'),
                  _buildDetailRow(Icons.card_giftcard, '赠送数量',
                      record.receiveCount?.toString() ?? '0'),
                ]),

                SizedBox(height: pt(16)),

                /// 其他信息卡片
                _buildDetailCard('其他信息', [
                  _buildDetailRow(
                      Icons.business, '租户', record.tenant?.name ?? '未知'),
                  _buildDetailRow(
                      Icons.qr_code, '原始码', record.originCode ?? '无'),
                ]),
              ],
            ),
          ),

          /// 操作按钮
          Container(
            padding: EdgeInsets.all(pt(16)),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context
                          .read<GiftRecordsCtrl>()
                          .refreshRecordStatus(record.id.toString());
                      SportsToast.showText('正在刷新状态...');
                    },
                    child: const Text('刷新状态'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 获取彩种名称
  String _getLotteryTypeName(int? lotteryType) {
    return LotteryType.fromValue(lotteryType!).displayName;
  }

  /// 获取生成方式文本
  String _getGenerateTypeText(String? type) {
    switch (type) {
      case 'dynamic':
        return '动态二维码';
      default:
        return type ?? '静态二维码';
    }
  }

  /// 格式化详情页面的日期时间
  String _formatDetailDateTime(int? timestamp) {
    if (timestamp == null) return '未知时间';
    return DateFormat('yyyy-MM-dd HH:mm:ss', 'zh_CN')
        .format(DateTime.utc(timestamp));
  }

  /// 构建详情卡片
  Widget _buildDetailCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(pt(12)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 卡片标题
          Container(
            padding: EdgeInsets.all(pt(16)),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: pt(4),
                  height: pt(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(pt(2)),
                  ),
                ),
                SizedBox(width: pt(8)),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: pt(16),
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          /// 卡片内容
          Padding(
            padding: EdgeInsets.all(pt(16)),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建详情行
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: pt(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: pt(18),
            color: Colors.grey[600],
          ),
          SizedBox(width: pt(12)),
          SizedBox(
            width: pt(80),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: pt(14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: pt(14),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建排序按钮
  Widget _buildSortButton(BuildContext context) {
    final isDesc = state.filter.orderByType == 'DESC';
    return GestureDetector(
      onTap: () {
        final newOrder = isDesc ? 'ASC' : 'DESC';
        context.read<GiftRecordsCtrl>().updateSort('createTime', newOrder);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: pt(12), vertical: pt(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isDesc ? '按时间倒序' : '按时间升序',
              style: TextStyle(
                fontSize: pt(14),
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: pt(4)),
            Icon(
              isDesc ? Icons.arrow_downward : Icons.arrow_upward,
              color: AppColors.primary,
              size: pt(18),
            ),
          ],
        ),
      ),
    );
  }
}
