import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup_success/widgets/receipt_card.dart';
import 'package:oil_business_app/pages/oil_pickup_success/widgets/save_share_sheet.dart';
import 'package:oil_business_app/pages/pickup_order_detail/controller.dart';
import 'package:oil_business_app/pages/pickup_order_detail/utils/certificate_image_saver.dart';
import 'package:oil_business_app/pages/pickup_order_detail/utils/vehicle_info_parser.dart';
import 'package:oil_business_app/pages/pickup_order_detail/widgets/action_buttons.dart';
import 'package:oil_business_app/pages/pickup_order_detail/widgets/waybill_card.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';

/// 提油订单详情页面
///
/// 展示订单的完整信息，包括运单卡片和操作按钮
class PickupOrderDetailScreen extends StatefulWidget {
  final WithdrawOrderModel? order;

  const PickupOrderDetailScreen({
    Key? key,
    this.order,
  }) : super(key: key);

  @override
  State<PickupOrderDetailScreen> createState() =>
      _PickupOrderDetailScreenState();
}

class _PickupOrderDetailScreenState extends State<PickupOrderDetailScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    // 空订单处理
    if (widget.order == null) {
      return _buildEmptyState();
    }

    // 解析车辆信息
    final VehicleModel? vehicleModel =
        VehicleInfoParser.parse(widget.order!.vehicleInfo);

    // 判断订单状态
    final bool isPendingPickup =
        widget.order!.status == WithdrawStatus.pendingPickup.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              // 主内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.setWidth(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: AppSizes.setHeight(20)),
                      WaybillCard(
                        order: widget.order!,
                        vehicleModel: vehicleModel,
                      ),
                      SizedBox(height: AppSizes.setHeight(30)),
                    ],
                  ),
                ),
              ),

              // 底部操作按钮（仅待提油状态显示）
              if (isPendingPickup)
                ActionButtons(
                  onCancel: () => _handleCancel(context),
                  onSaveCertificate: _saveCertificateImage,
                  isSaving: _isSaving,
                ),
            ],
          ),

          // 隐藏的凭证卡片（用于生成图片）
          _buildHiddenReceiptCard(vehicleModel),

          // 保存中的加载遮罩
          if (_isSaving) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  /// 构建 AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
      title: CommonText(
        text: '订单详情',
        fontSize: AppSizes.setFontSize(17),
        fontWeight: FontWeight.w600,
        textColor: const Color(0xFF1F2937),
      ),
      centerTitle: true,
    );
  }

  /// 构建空状态页面
  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: Center(
        child: CommonText(
          text: '订单信息不存在',
          fontSize: AppSizes.setFontSize(14),
          textColor: const Color(0xFF6B7280),
        ),
      ),
    );
  }

  /// 构建隐藏的凭证卡片（用于截图生成图片）
  Widget _buildHiddenReceiptCard(VehicleModel? vehicleModel) {
    return Positioned(
      left: 9999,
      child: RepaintBoundary(
        key: _cardKey,
        child: SizedBox(
          width: AppSizes.setWidth(375 - 32),
          child: OilPickupReceiptCard(
            response: WithdrawResponse(
              withdrawNo: widget.order!.withdrawNo,
              withdrawId: widget.order!.withdrawId,
              status: widget.order!.status,
            ),
            inventory: InventoryModel(
              inventoryId: widget.order!.inventoryId,
            ),
            station: Station(
              id: widget.order!.stationId,
              stationName: widget.order!.stationName,
            ),
            oilAmount: widget.order!.withdrawTon?.toString() ?? '0',
            dispatchContent: VehicleInfoParser.getDispatchContent(vehicleModel),
            onCopyWithdrawNo: (_) {},
            showCopyIcon: false,
          ),
        ),
      ),
    );
  }

  /// 构建加载遮罩
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// 处理取消订单
  void _handleCancel(BuildContext context) {
    SportsDialog.show(
      title: '取消订单',
      bodyText: '确定要取消该提油订单吗？取消后无法恢复。',
      onCancel: () {},
      onOk: () async {
        await SportsDialog.dismiss();
        if (context.mounted) {
          final success =
              await context.read<PickupOrderDetailCtrl>().cancelOrder();
          if (success && context.mounted) {
            Navigator.pop(context, true);
          }
        }
      },
    );
  }

  /// 保存凭证图片
  Future<void> _saveCertificateImage() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      // 生成图片
      final Uint8List pngBytes =
          await CertificateImageSaver.captureImage(_cardKey) ??
              (throw Exception('生成图片失败'));

      // 保存临时文件
      final String filePath =
          await CertificateImageSaver.saveTempFile(pngBytes);

      if (!mounted) return;
      setState(() => _isSaving = false);

      // 显示保存/分享选项
      await _showSaveShareSheet(pngBytes, filePath);
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('保存失败，请重试');
      setState(() => _isSaving = false);
    }
  }

  /// 显示保存/分享底部弹窗
  Future<void> _showSaveShareSheet(Uint8List bytes, String filePath) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SaveShareSheet(
          previewBytes: bytes,
          onSaveToGallery: () async {
            Navigator.of(context).pop();
            await _saveToGallery(bytes);
          },
          onSaveToDirectory: () async {
            Navigator.of(context).pop();
            await _saveToDirectory(bytes);
          },
          onShare: () async {
            Navigator.of(context).pop();
            await CertificateImageSaver.shareImage(filePath);
          },
        );
      },
    );
  }

  /// 保存到相册
  Future<void> _saveToGallery(Uint8List bytes) async {
    try {
      final result = await CertificateImageSaver.saveToGallery(bytes);
      final dynamic filePath =
          result['filePath'] ?? result['filePathList']?.first;

      _showSuccessSnackBar(
        filePath != null ? '已保存到相册 $filePath' : '已保存到相册',
      );
    } catch (e) {
      _showErrorSnackBar('保存到相册失败，请检查权限');
    }
  }

  /// 保存到指定目录
  Future<void> _saveToDirectory(Uint8List bytes) async {
    try {
      final String? filePath =
          await CertificateImageSaver.saveToDirectory(bytes);

      if (filePath != null) {
        _showSuccessSnackBar('图片已保存：$filePath');
      }
    } catch (e) {
      _showErrorSnackBar('保存失败，请重试');
    }
  }

  /// 显示成功提示
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 显示错误提示
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
