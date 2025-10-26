import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:lottery_app/config/address.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/model/common_type.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/widgets/full_image.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/popup/toast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class StaticItem extends StatefulWidget {
  final QrCodeStaticItem staticCode;
  const StaticItem({super.key, required this.staticCode});

  @override
  State<StaticItem> createState() => _StaticItemState();
}

class _StaticItemState extends State<StaticItem> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
  }

  /// 构建二维码图片
  Widget _buildQrCodeImage(
    QrCodeStaticItem staticCode,
    BuildContext context, {
    double? size,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(pt(8)),
        border: Border.all(color: AppColors.divider),
      ),
      child: QrImageView(
        data: '${BaseAddress.clientBaseUrl}?code=${staticCode.uuid}',
        version: QrVersions.auto,
        padding: EdgeInsets.all(pt(5)),
        size: size ?? pt(200),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: pt(16)),
      padding: EdgeInsets.all(pt(16)),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 二维码和基本信息
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 二维码
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => FullImage(
                        heroTag: '${widget.staticCode.uuid}_qr_code_full',
                        child: _buildQrCodeImage(
                          widget.staticCode,
                          context,
                          size: pt(300),
                        ),
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: '${widget.staticCode.uuid}_qr_code_full',
                  child: Container(
                    width: pt(80),
                    height: pt(80),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(pt(8)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(pt(8)),
                      child: Screenshot(
                        controller: screenshotController,
                        child: _buildQrCodeImage(
                          widget.staticCode,
                          context,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: pt(16)),

              /// 基本信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// URL
                    Text(
                      '${BaseAddress.clientBaseUrl}?code=${widget.staticCode.uuid}',
                      style: TextStyle(
                        fontSize: pt(12),
                        color: AppColors.primary,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: pt(8)),

                    /// 过期时间
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: pt(14),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: pt(4)),
                        Text(
                          '过期时间: ${_formatDateTime(widget.staticCode.expireTime)}',
                          style: TextStyle(
                            fontSize: pt(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: pt(4)),

                    /// 生成员工
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: pt(14),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: pt(4)),
                        Text(
                          '生成人员: ${widget.staticCode.creatorName}',
                          style: TextStyle(
                            fontSize: pt(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(width: pt(50)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: pt(6),
                            vertical: pt(2),
                          ),
                          decoration: BoxDecoration(
                            color: widget.staticCode.status ==
                                    QrCodeStatus.unredeemed
                                ? AppColors.success
                                : AppColors.error,
                            borderRadius: BorderRadius.circular(pt(10)),
                          ),
                          child: Text(
                            widget.staticCode.status.displayName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: pt(10),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: pt(16)),

          /// 操作按钮
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => {
                    saveQrCodeToPhone(),
                  },
                  icon: Icon(Icons.save_alt, size: pt(16)),
                  label: const Text('保存二维码到手机'),
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
                  onPressed: () => {
                    copyTextToClipboard(
                      '${BaseAddress.clientBaseUrl}?code=${widget.staticCode.uuid}',
                    ),
                  },
                  icon: Icon(Icons.copy, size: pt(16)),
                  label: const Text('复制领取链接'),
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

  /// 保存二维码到手机
  void saveQrCodeToPhone() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((Uint8List? image) async {
      if (image != null) {
        await ImageGallerySaverPlus.saveImage(image, name: 'qr_code.png');
        SportsToast.show('保存成功', ToastType.success);
      }
    });
  }

  void copyTextToClipboard(String textToCopy) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    SportsToast.show('复制成功', ToastType.success);
  }

  /// 格式化日期时间
  String _formatDateTime(int dateTime) {
    final date = DateTime.fromMillisecondsSinceEpoch(dateTime);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }
}
