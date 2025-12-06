import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup_success/widgets/receipt_card.dart';
import 'package:oil_business_app/pages/oil_pickup_success/widgets/save_share_sheet.dart';
import 'package:oil_business_app/pages/pickup_order_detail/controller.dart';
import 'package:oil_business_app/pages/pickup_order_detail/state.dart';
import 'package:oil_business_app/pages/pickup_order_detail/utils/certificate_image_saver.dart';
import 'package:oil_business_app/pages/pickup_order_detail/utils/vehicle_info_parser.dart';
import 'package:oil_business_app/pages/pickup_order_detail/widgets/order_detail_header.dart';
import 'package:oil_business_app/pages/pickup_order_detail/widgets/order_detail_bottom_actions.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';

/// 提油订单详情页面
///
/// 展示订单的完整信息，包括运单卡片和操作按钮
class PickupOrderDetailScreen extends StatefulWidget {
  final PickupOrderDetailState state;

  const PickupOrderDetailScreen({
    Key? key,
    required this.state,
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
    final WithdrawOrderModel? order = widget.state.order;

    if (widget.state.isLoading && order == null) {
      return _buildLoadingState();
    }

    if (widget.state.errorMessage != null && order == null) {
      return _buildErrorState(widget.state.errorMessage!);
    }

    // 空订单处理
    if (order == null) {
      return _buildEmptyState();
    }

    // 解析车辆信息
    final VehicleModel? vehicleModel =
        VehicleInfoParser.parse(order.vehicleInfo);

    // 判断订单状态
    final bool isPendingPickup =
        order.status == WithdrawStatus.pendingPickup.value;

    final double horizontalPadding = AppSizes.setWidth(16);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      body: _buildBody(
        horizontalPadding,
        vehicleModel,
        isPendingPickup,
        order,
      ),
    );
  }

  /// 构建加载状态
  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      body: Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
        ),
      ),
    );
  }

  /// 构建错误状态
  Widget _buildErrorState(String message) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText(
              text: message,
              fontSize: AppSizes.setFontSize(14),
              textColor: const Color(0xFF6B7280),
            ),
            SizedBox(height: AppSizes.setHeight(12)),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: CommonText(
                text: '返回',
                fontSize: AppSizes.setFontSize(14),
                textColor: CustomAppColor.of(context).txtPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建 AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: CustomAppColor.of(context).bgScaffold,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: CustomAppColor.of(context).txtBlack,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: CommonText(
        text: '订单详情',
        fontSize: AppSizes.setFontSize(18),
        fontWeight: FontWeight.w600,
        textColor: CustomAppColor.of(context).txtBlack,
      ),
      centerTitle: true,
    );
  }

  /// 构建页面主体
  Widget _buildBody(
    double horizontalPadding,
    VehicleModel? vehicleModel,
    bool isPendingPickup,
    WithdrawOrderModel order,
  ) {
    final String dispatchContent = VehicleInfoParser.getDispatchContent(
      vehicleModel,
      vehicleInfo: order.vehicleInfo,
    );

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: AppSizes.setHeight(16),
                  ),
                  child: Column(
                    children: [
                      OrderDetailHeader(status: order.status),
                      SizedBox(height: AppSizes.setHeight(16)),
                      OilPickupReceiptCard(
                        response: WithdrawResponse(
                          withdrawNo: order.withdrawNo,
                          withdrawId: order.withdrawId,
                          status: order.status,
                        ),
                        inventory: InventoryModel(
                          depotName: order.depot?.depotName,
                          fuelType: order.fuelType,
                        ),
                        station: Station(
                          id: order.station?.stationId,
                          stationName: order.station?.stationName,
                        ),
                        oilAmount: order.withdrawTon?.toString() ?? '0',
                        dispatchContent: dispatchContent,
                        onCopyWithdrawNo: _copyWithdrawNo,
                        showCopyIcon: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 底部操作按钮（仅待提油状态显示）
            if (isPendingPickup)
              OrderDetailBottomActions(
                isSaving: _isSaving,
                onCancel: () => _handleCancel(context),
                onSave: _isSaving ? null : _saveCertificateImage,
              ),
          ],
        ),
        // 隐藏的凭证卡片（用于生成图片）
        Positioned(
          left: -10000,
          top: -10000,
          child: RepaintBoundary(
            key: _cardKey,
            child: SizedBox(
              width: AppSizes.setWidth(375 - 32),
              child: OilPickupReceiptCard(
                response: WithdrawResponse(
                  withdrawNo: order.withdrawNo,
                  withdrawId: order.withdrawId,
                  status: order.status,
                ),
                inventory: InventoryModel(
                  depotName: order.depot?.depotName,
                  fuelType: order.fuelType,
                ),
                station: Station(
                  id: order.station?.stationId,
                  stationName: order.station?.stationName,
                ),
                oilAmount: order.withdrawTon?.toString() ?? '0',
                dispatchContent: dispatchContent,
                onCopyWithdrawNo: (_) {},
                showCopyIcon: false,
              ),
            ),
          ),
        ),
        if (widget.state.isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.05),
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            ),
          ),
      ],
    );
  }

  /// 复制提油单号
  Future<void> _copyWithdrawNo(String withdrawNo) async {
    if (withdrawNo == '--') return;
    await Clipboard.setData(ClipboardData(text: withdrawNo));
    if (!mounted) return;
    _showSnackBar('提油单号已复制');
  }

  /// 构建空状态页面
  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      body: Center(
        child: CommonText(
          text: '订单信息不存在',
          fontSize: AppSizes.setFontSize(14),
          textColor: const Color(0xFF6B7280),
        ),
      ),
    );
  }

  /// 处理取消订单
  void _handleCancel(BuildContext context) {
    if (widget.state.isLoading) return;

    SportsDialog.show(
      title: '取消订单',
      bodyText: '确定要取消该提油订单吗？取消后无法恢复。',
      onCancel: () {},
      onOk: () async {
        await SportsDialog.dismiss();
        if (context.mounted) {
          context.read<PickupOrderDetailCtrl>().cancelOrder();
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
      _showSnackBar('保存失败，请重试');
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

      _showSnackBar(
        filePath != null ? '已保存到相册 $filePath' : '已保存到相册',
      );
    } catch (e) {
      _showSnackBar('保存到相册失败，请检查权限');
    }
  }

  /// 保存到指定目录
  Future<void> _saveToDirectory(Uint8List bytes) async {
    try {
      final String? filePath =
          await CertificateImageSaver.saveToDirectory(bytes);

      if (filePath != null) {
        _showSnackBar('图片已保存：$filePath');
      }
    } catch (e) {
      _showSnackBar('保存失败，请重试');
    }
  }

  /// 显示提示
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
