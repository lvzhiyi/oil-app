import 'package:flutter/material.dart';
import 'package:lottery_app/pages/gift_lottery_qr_dynamic/model/common_type.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplay extends StatelessWidget {
  final QrCodeDynamicInfo qrCode;
  final bool showActions;
  final VoidCallback? onRefresh;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final bool isExpired;
  final bool isGenerating;
  final int dynamicRefreshCountdown;

  const QrCodeDisplay({
    Key? key,
    required this.qrCode,
    this.showActions = true,
    this.onRefresh,
    this.onShare,
    this.onSave,
    this.isExpired = false,
    this.isGenerating = false,
    this.dynamicRefreshCountdown = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          /// 标题和状态
          Row(
            children: [
              Container(
                width: pt(40),
                height: pt(40),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(pt(12)),
                ),
                child: Icon(
                  Icons.qr_code_2,
                  color: AppColors.success,
                  size: pt(20),
                ),
              ),
              SizedBox(width: pt(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '扫描二维码即可领取彩票',
                      style: TextStyle(
                        fontSize: pt(14),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (dynamicRefreshCountdown > 0)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: pt(8), vertical: pt(4)),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(pt(12)),
                  ),
                  child: Text(
                    '${dynamicRefreshCountdown}s后过期',
                    style: TextStyle(
                      fontSize: pt(12),
                      color: AppColors.warning,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: pt(20)),

          /// 二维码图片
          Center(
            child: Container(
              // padding: EdgeInsets.all(pt(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(pt(12)),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: _buildQrCodeImage(),
            ),
          ),
          SizedBox(height: pt(20)),

          /// 操作按钮
          if (showActions)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _saveQrCodeToPhone(),
                    icon: Icon(Icons.save_alt, size: pt(16)),
                    label: const Text('保存二维码'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: EdgeInsets.symmetric(vertical: pt(8)),
                    ),
                  ),
                ),
                SizedBox(width: pt(12)),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copyTextToClipboard(),
                    icon: Icon(Icons.copy, size: pt(16)),
                    label: const Text('复制链接'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.success,
                      side: BorderSide(color: AppColors.success),
                      padding: EdgeInsets.symmetric(vertical: pt(8)),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // /// 构建二维码信息头部
  // Widget _buildQrCodeHeader() {
  //   return Row(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.symmetric(horizontal: pt(8), vertical: pt(4)),
  //         decoration: BoxDecoration(
  //           color: const Color(0xFFE3F2FD),
  //           borderRadius: BorderRadius.circular(pt(4)),
  //         ),
  //         child: Text(
  //           qrCode.lotteryType?.displayName ?? '',
  //           style: TextStyle(
  //             fontSize: pt(12),
  //             color: AppColors.primary,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //       const Spacer(),
  //       // Container(
  //       //   padding: EdgeInsets.symmetric(horizontal: pt(8), vertical: pt(4)),
  //       //   decoration: BoxDecoration(
  //       //     color: Colors.red,
  //       //     borderRadius: BorderRadius.circular(pt(4)),
  //       //   ),
  //       //   child: Text(
  //       //     qrCode.isExpired ? '已过期' : '有效',
  //       //     style: const TextStyle(
  //       //       fontSize: pt(12),
  //       //       color: Colors.white,
  //       //       fontWeight: FontWeight.w500,
  //       //     ),
  //       //   ),
  //       // ),
  //       // const Spacer(),
  //       // Text(
  //       //   qrCode.qrType?.displayName ?? '',
  //       //   style: TextStyle(
  //       //     fontSize: pt(12),
  //       //     color: AppColors.textSecondary,
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

  /// 构建二维码图片
  Widget _buildQrCodeImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(pt(8)),
        border: Border.all(color: AppColors.divider),
      ),
      child: Stack(
        children: [
          QrImageView(
            data: qrCode.url ?? '',
            version: QrVersions.auto,
            size: pt(300),
            gapless: false,
            constrainErrorBounds: true,
            backgroundColor: Colors.white,
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.black,
            ),
            errorCorrectionLevel: QrErrorCorrectLevel.M,
          ),
          if (isExpired)
            Positioned.fill(
              child: GestureDetector(
                onTap: onRefresh,
                child: Container(
                  color: AppColors.textGray2.withValues(alpha: 0.8),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '二维码过期',
                          style: TextStyle(
                            fontSize: pt(20),
                            color: AppColors.appText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: pt(5)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isGenerating)
                              SizedBox(
                                width: pt(20),
                                height: pt(20),
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              )
                            else
                              Icon(
                                Icons.refresh,
                                size: pt(20),
                                color: AppColors.primary,
                              ),
                            SizedBox(width: pt(5)),
                            Text(
                              '点击刷新',
                              style: TextStyle(
                                fontSize: pt(18),
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  /// 保存二维码到手机
  void _saveQrCodeToPhone() {}

  /// 复制链接到剪贴板
  void _copyTextToClipboard() {}
}
