import 'package:flutter/material.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/gift_records/model/gift_records_response.dart';
import 'package:lottery_app/utils/date_util.dart';
import 'package:lottery_app/utils/pt.dart';

class GiftRecordItemWidget extends StatelessWidget {
  final GiftRecordItem recordData;
  final VoidCallback? onTap;

  const GiftRecordItemWidget({
    Key? key,
    required this.recordData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(16), vertical: pt(6)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: pt(8),
            offset: Offset(0, pt(2)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: null,
          borderRadius: BorderRadius.circular(pt(12)),
          child: Padding(
            padding: EdgeInsets.all(pt(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _getLotteryTypeName(recordData.lotteryType),
                      style: TextStyle(
                        fontSize: pt(15),
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: pt(8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: pt(8), vertical: pt(3)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(pt(12)),
                      ),
                      child: Text(
                        _getGenerateTypeText(recordData.type),
                        style: TextStyle(
                          fontSize: pt(11),
                          color: const Color(0xFF1976D2),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (recordData.type == 'static')
                          Text(
                            '生成${recordData.num ?? '0'}张',
                            style: TextStyle(
                              fontSize: pt(14),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                        if (recordData.type == 'dynamic')
                          Text(
                            '赠送${recordData.receiveCount ?? 0}张',
                            style: TextStyle(
                              fontSize: pt(14),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF9800),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: pt(10)),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: pt(16),
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: pt(6)),
                    Text(
                      '员工姓名：${recordData.creator?.username ?? '未知'}',
                      style: TextStyle(
                        fontSize: pt(13),
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: pt(8)),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: pt(16),
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: pt(6)),
                    Text(
                      '赠送时间：${_formatFullDateTime(recordData.createTime)}',
                      style: TextStyle(
                        fontSize: pt(13),
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 获取生成方式文本
  String _getGenerateTypeText(String? type) {
    switch (type) {
      case 'manual':
        return '手动生成';
      case 'auto':
        return '自动生成';
      case 'batch':
        return '批量生成';
      case 'dynamic':
        return '动态生成';
      case 'static':
        return '静态生成';
      default:
        return type ?? '未知方式';
    }
  }

  /// 获取彩种名称
  String _getLotteryTypeName(int? lotteryType) {
    return LotteryType.fromValue(lotteryType!).displayName;
  }

  /// 格式化完整日期时间
  String _formatFullDateTime(int? timestamp) {
    return formatDateFromMilliSecond(timestamp!, format: 'yyyy-MM-dd HH:mm:ss');
  }
}
