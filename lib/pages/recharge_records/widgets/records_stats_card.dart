import 'package:flutter/material.dart';
import 'package:lottery_app/pages/gift_records/model/common_type.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';

class RecordsStatsCard extends StatelessWidget {
  final GiftRecordStats stats;

  const RecordsStatsCard({Key? key, required this.stats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(pt(12)),
      ),
      child: Padding(
        padding: EdgeInsets.all(pt(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 标题
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: AppColors.primary,
                  size: pt(20),
                ),
                SizedBox(width: pt(8)),
                Text(
                  '数据统计',
                  style: TextStyle(
                    fontSize: pt(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: pt(16)),

            /// 统计数据网格
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '今日赠送',
                    stats.todayGiftCount.toString(),
                    '张',
                    Colors.blue,
                  ),
                ),
                SizedBox(width: pt(12)),
                Expanded(
                  child: _buildStatItem(
                    '累计赠送',
                    stats.totalGiftCount.toString(),
                    '张',
                    Colors.green,
                  ),
                ),
              ],
            ),

            SizedBox(height: pt(12)),

            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '今日中奖',
                    stats.todayWinCount.toString(),
                    '张',
                    Colors.orange,
                  ),
                ),
                SizedBox(width: pt(12)),
                Expanded(
                  child: _buildStatItem(
                    '累计中奖',
                    stats.totalWinCount.toString(),
                    '张',
                    Colors.red,
                  ),
                ),
              ],
            ),

            SizedBox(height: pt(12)),

            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '今日奖金',
                    stats.todayWinAmount.toStringAsFixed(2),
                    '元',
                    Colors.purple,
                  ),
                ),
                SizedBox(width: pt(12)),
                Expanded(
                  child: _buildStatItem(
                    '累计奖金',
                    stats.totalWinAmount.toStringAsFixed(2),
                    '元',
                    Colors.teal,
                  ),
                ),
              ],
            ),

            SizedBox(height: pt(16)),

            /// 中奖率信息
            Container(
              padding: EdgeInsets.all(pt(12)),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(pt(8)),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRateItem(
                    '累计中奖率',
                    stats.totalGiftCount > 0
                        ? '${(stats.totalWinCount / stats.totalGiftCount * 100).toStringAsFixed(1)}%'
                        : '0%',
                  ),
                  Container(
                    width: pt(1),
                    height: pt(20),
                    color: Colors.grey[300],
                  ),
                  _buildRateItem(
                    '今日中奖率',
                    stats.todayGiftCount > 0
                        ? '${(stats.todayWinCount / stats.todayGiftCount * 100).toStringAsFixed(1)}%'
                        : '0%',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String label, String value, String unit, Color color) {
    return Container(
      padding: EdgeInsets.all(pt(12)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(pt(8)),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: pt(12),
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: pt(4)),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: pt(18),
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                    fontSize: pt(12),
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建比率项
  Widget _buildRateItem(String label, String rate) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: pt(12),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: pt(4)),
        Text(
          rate,
          style: TextStyle(
            fontSize: pt(16),
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
