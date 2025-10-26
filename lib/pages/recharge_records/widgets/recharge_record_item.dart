import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/recharge_records/controller.dart';
import 'package:lottery_app/pages/recharge_records/model/common_type.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/router/router.dart';
import 'package:lottery_app/router/routes.dart';
import 'package:lottery_app/utils/pt.dart';

class RechargeRecordItem extends StatelessWidget {
  final RechargeRecord record;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSelect;

  const RechargeRecordItem({
    Key? key,
    required this.record,
    this.isSelected = false,
    this.onTap,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await BaseRouter.push(
          url: AppPage.payOrderDetailPage.path,
          extra: record.uuid,
        );
        if (context.mounted) {
          context.read<RechargeRecordsCtrl>().loadRecords();
          BaseConfig.appContext?.read<AppController>().fetchAgentInfo();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(pt(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: pt(8),
              offset: Offset(0, pt(2)),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(pt(12)),
            child: Padding(
              padding: EdgeInsets.all(pt(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 头部信息行
                  Row(
                    children: [
                      // 充值类型和状态
                      Expanded(
                        child: Row(
                          children: [
                            // 充值类型标签
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: pt(8), vertical: pt(4)),
                              decoration: BoxDecoration(
                                color: _getRechargeTypeColor(record.type)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(pt(12)),
                                border: Border.all(
                                  color: _getRechargeTypeColor(record.type)
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                record.type.displayName,
                                style: TextStyle(
                                  fontSize: pt(12),
                                  color: _getRechargeTypeColor(record.type),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            SizedBox(width: pt(8)),

                            // 状态标签
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: pt(8), vertical: pt(4)),
                              decoration: BoxDecoration(
                                color:
                                    record.statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(pt(12)),
                                border: Border.all(
                                  color:
                                      record.statusColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                OrderStatus.fromValue(record.status)
                                    .displayName,
                                style: TextStyle(
                                  fontSize: pt(12),
                                  color: record.statusColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 支付金额
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '¥${record.payAmount}',
                            style: TextStyle(
                              fontSize: pt(18),
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '支付金额',
                            style: TextStyle(
                              fontSize: pt(12),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: pt(20)),

                      Icon(
                        Icons.arrow_forward_ios,
                        size: pt(16),
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),

                  SizedBox(height: pt(16)),

                  // 详细信息行
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '订单编号: ',
                            style: TextStyle(
                              fontSize: pt(14),
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: pt(6)),
                          Icon(
                            Icons.receipt_long,
                            size: pt(16),
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: pt(6)),
                          Flexible(
                            child: Text(
                              record.uuid,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: pt(14),
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: pt(8)),
                      // 充值时间
                      Row(
                        children: [
                          Text(
                            '提交时间：',
                            style: TextStyle(
                              fontSize: pt(14),
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Icon(
                            Icons.access_time,
                            size: pt(16),
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: pt(6)),
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    record.createTime)),
                            style: TextStyle(
                              fontSize: pt(14),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: pt(8)),
                      // 订单完成时间
                      Row(
                        children: [
                          Text(
                            record.status == OrderStatus.Success.value
                                ? '完成时间：'
                                : '更新时间：',
                            style: TextStyle(
                              fontSize: pt(14),
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Icon(
                            Icons.access_time,
                            size: pt(16),
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: pt(6)),
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    record.updateTime)),
                            style: TextStyle(
                              fontSize: pt(14),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: pt(8)),

                      // 支付方式
                      Row(
                        children: [
                          Text(
                            '支付方式：',
                            style: TextStyle(
                              fontSize: pt(14),
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Icon(
                            _getPaymentMethodIcon(record.paymentMethod),
                            size: pt(16),
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: pt(6)),
                          Text(
                            record.paymentMethod.displayName,
                            style: TextStyle(
                              fontSize: pt(14),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: pt(8)),

                      // 套餐数量（如果是套餐购买）
                      if (record.type == RechargeType.package)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '套餐数量: ',
                                      style: TextStyle(
                                        fontSize: pt(14),
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(width: pt(6)),
                                    Icon(
                                      Icons.sports_soccer,
                                      size: pt(16),
                                      color: AppColors.textSecondary,
                                    ),
                                    SizedBox(width: pt(6)),
                                    Text(
                                      record.quota,
                                    ),
                                  ],
                                ),
                                SizedBox(width: pt(6)),

                                // 彩票类型（如果是套餐购买）
                                if (record.type == RechargeType.package &&
                                    record.lotteryType != null) ...[
                                  SizedBox(height: pt(8)),
                                  Row(
                                    children: [
                                      SizedBox(width: pt(6)),
                                      Text(
                                        record.lotteryType!.displayName,
                                        style: TextStyle(
                                          fontSize: pt(14),
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),

                      SizedBox(height: pt(8)),

                      // 备注（如果有）
                      if (record.remark != null &&
                          record.remark!.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '订单备注：',
                              style: TextStyle(
                                fontSize: pt(14),
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(width: pt(6)),
                            Expanded(
                              child: Text(
                                record.remark!,
                                style: TextStyle(
                                  fontSize: pt(14),
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 获取充值类型对应的颜色
  Color _getRechargeTypeColor(RechargeType type) {
    switch (type) {
      case RechargeType.balance:
        return Colors.blue;
      case RechargeType.package:
        return Colors.orange;
      default:
        return Colors.orange;
    }
  }

  /// 获取支付方式对应的图标
  IconData _getPaymentMethodIcon(PaymentMethod paymentMethod) {
    switch (paymentMethod) {
      case PaymentMethod.CorpToCorp:
        return Icons.account_balance;
      case PaymentMethod.Heepay:
        return Icons.payment;
    }
  }
}
