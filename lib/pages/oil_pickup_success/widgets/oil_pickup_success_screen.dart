import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/utils/constant.dart';
import 'package:oil_business_app/utils/fuel_type_helper.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/station_extension.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:path_provider/path_provider.dart';

import '../../pickup_order_detail/widgets/pickup_order_detail_screen.dart';

class OilPickupSuccessScreen extends StatefulWidget {
  final WithdrawResponse response;
  final InventoryModel inventory;
  final Station station;
  final String oilAmount;
  final VehicleModel vehicleModel;
  final String dispatchInfo;

  const OilPickupSuccessScreen({
    Key? key,
    required this.response,
    required this.inventory,
    required this.station,
    required this.oilAmount,
    required this.vehicleModel,
    required this.dispatchInfo,
  }) : super(key: key);

  @override
  State<OilPickupSuccessScreen> createState() => _OilPickupSuccessScreenState();
}

class _OilPickupSuccessScreenState extends State<OilPickupSuccessScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSizes.setWidth(16);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: CustomAppColor.of(context).bgScaffold,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomAppColor.of(context).txtBlack,
          ),
          onPressed: () => _handleBack(context),
        ),
        title: CommonText(
          text: '提油成功',
          fontSize: AppSizes.setFontSize(18),
          fontWeight: FontWeight.w600,
          textColor: CustomAppColor.of(context).txtBlack,
        ),
        centerTitle: true,
      ),
      body: Column(
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
                    _buildSuccessHeader(context),
                    SizedBox(height: AppSizes.setHeight(16)),
                    RepaintBoundary(
                      key: _cardKey,
                      child: _buildReceiptCard(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: AppSizes.setWidth(76),
          height: AppSizes.setWidth(76),
          decoration: const BoxDecoration(
            color: Color(0xFFE3F8E8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            size: AppSizes.setWidth(40),
            color: CustomAppColor.of(context).green,
          ),
        ),
        SizedBox(height: AppSizes.setHeight(12)),
        CommonText(
          text: '提油凭证生成成功',
          fontSize: AppSizes.setFontSize(18),
          fontWeight: FontWeight.w600,
          textColor: CustomAppColor.of(context).txtBlack,
        ),
        SizedBox(height: AppSizes.setHeight(6)),
        CommonText(
          text: '请保存下方图片发送给司机',
          fontSize: AppSizes.setFontSize(13),
          fontWeight: FontWeight.w400,
          textColor: const Color(0xff6B7280),
        ),
      ],
    );
  }

  Widget _buildReceiptCard(BuildContext context) {
    final String statusLabel = widget.response.status != null
        ? (WithdrawStatus.fromString(widget.response.status)?.displayName ??
            widget.response.status!)
        : '待提油';
    final String withdrawNo = widget.response.withdrawNo ??
        widget.response.withdrawId?.toString() ??
        '--';
    final String productName = widget.inventory.fuelType != null
        ? FuelTypeHelper.getDisplayName(widget.inventory.fuelType)
        : '油品';
    final String formattedAmount = _formatOilAmount(widget.oilAmount);
    final String depotName =
        widget.inventory.depotName?.trim().isNotEmpty == true
            ? widget.inventory.depotName!
            : '--';
    final String stationName = widget.station.displayName.isNotEmpty
        ? widget.station.displayName
        : '--';
    final String dispatchDetail = _dispatchContent;

    return Container(
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStripeBar(),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSizes.setHeight(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(context, statusLabel),
                SizedBox(height: AppSizes.setHeight(12)),
                _buildDashedDivider(),
                // SizedBox(height: AppSizes.setHeight(6)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.setWidth(18),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: AppSizes.setHeight(18)),
                      _buildWithdrawNo(context, withdrawNo),
                      SizedBox(height: AppSizes.setHeight(12)),
                      _buildAmountPanel(context, productName, formattedAmount),
                      SizedBox(height: AppSizes.setHeight(18)),
                      _buildLocationRow(context, depotName, stationName),
                      SizedBox(height: AppSizes.setHeight(18)),
                      _buildDispatchDetail(context, dispatchDetail),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return CustomPaint(
      painter: DashedLinePainter(
        color: const Color(0xFFE5E7EB),
        strokeWidth: 1,
        dashWidth: 4,
        dashSpace: 4,
      ),
      child: const SizedBox(
        height: 1,
        width: double.infinity,
      ),
    );
  }

  Widget _buildStripeBar() {
    return Container(
      height: AppSizes.setHeight(10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.repeated,
          colors: [
            Color(0xFF7C75F5),
            Color(0xFF7C75F5),
            Color(0xFF9D90F6),
            Color(0xFF9D90F6),
          ],
          stops: [0.0, 0.25, 0.25, 0.5],
          transform: GradientRotation(0.785398),
        ),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context, String statusLabel) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(14),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.water_drop_outlined,
                size: AppSizes.setWidth(18),
                color: CustomAppColor.of(context).txtPurple,
              ),
              SizedBox(width: AppSizes.setWidth(6)),
              CommonText(
                text: '买油呗提油单',
                fontSize: AppSizes.setFontSize(15),
                fontWeight: FontWeight.w700,
                textColor: CustomAppColor.of(context).txtBlack,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          const Spacer(),
          _buildStatusTag(context, statusLabel),
        ],
      ),
    );
  }

  Widget _buildStatusTag(BuildContext context, String statusLabel) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(10),
        vertical: AppSizes.setHeight(4),
      ),
      decoration: BoxDecoration(
        // color: CustomAppColor.of(context).btnPurple.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(5)),
        border: Border.all(
          color: CustomAppColor.of(context).btnPurple,
          width: AppSizes.setWidth(1),
        ),
      ),
      child: CommonText(
        text: statusLabel,
        fontSize: AppSizes.setFontSize(12),
        fontWeight: FontWeight.w600,
        textColor: CustomAppColor.of(context).txtPurple,
      ),
    );
  }

  Widget _buildWithdrawNo(BuildContext context, String withdrawNo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '提油单号 / NO.',
          style: TextStyle(
            fontSize: AppSizes.setFontSize(12),
            fontWeight: FontWeight.w500,
            color: const Color(0xff6B7280),
            height: 1,
          ),
        ),
        // SizedBox(height: AppSizes.setHeight(0)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                withdrawNo,
                style: TextStyle(
                  fontSize: AppSizes.setFontSize(16),
                  // fontWeight: FontWeight.w700,
                  color: CustomAppColor.of(context).txtBlack,
                  height: 1,
                  // fontFamily: Constant.fontFamilyUrbanist,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _copyWithdrawNo(withdrawNo),
              icon: Icon(
                Icons.copy_outlined,
                size: AppSizes.setWidth(18),
                color: CustomAppColor.of(context).txtPurple,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: AppSizes.setWidth(18),
              tooltip: '复制提油单号',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountPanel(
    BuildContext context,
    String productName,
    String formattedAmount,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(14),
        vertical: AppSizes.setHeight(12),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: '油品类型',
                  fontSize: AppSizes.setFontSize(12),
                  fontWeight: FontWeight.w500,
                  textColor: const Color(0xff6B7280),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: AppSizes.setHeight(6)),
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: AppSizes.setFontSize(18),
                    fontWeight: FontWeight.w500,
                    color: CustomAppColor.of(context).txtBlack,
                    fontFamily: Constant.fontFamilyUrbanist,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSizes.setWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CommonText(
                  text: '提油量',
                  fontSize: AppSizes.setFontSize(12),
                  fontWeight: FontWeight.w500,
                  textColor: const Color(0xff6B7280),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: AppSizes.setHeight(4)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formattedAmount,
                      style: TextStyle(
                        fontSize: AppSizes.setFontSize(28),
                        fontWeight: FontWeight.w600,
                        color: CustomAppColor.of(context).txtPurple,
                        fontFamily: Constant.fontFamilyUrbanist,
                        height: 1,
                      ),
                    ),
                    SizedBox(width: AppSizes.setWidth(4)),
                    Padding(
                      padding: EdgeInsets.only(top: AppSizes.setHeight(2)),
                      child: CommonText(
                        text: '吨',
                        fontSize: AppSizes.setFontSize(14),
                        fontWeight: FontWeight.w600,
                        textColor: CustomAppColor.of(context).txtBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(
    BuildContext context,
    String depotName,
    String stationName,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildLocationItem(
            context,
            label: '油库',
            value: depotName,
            icon: Icons.store_mall_directory_outlined,
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(left: AppSizes.setWidth(8), right: AppSizes.setWidth(8), top: AppSizes.setHeight(20)),
        //   child: Icon(
        //     Icons.arrow_forward,
        //     size: AppSizes.setWidth(18),
        //     color: CustomAppColor.of(context).txtGrey,
        //   ),
        // ),
        Expanded(
          child: _buildLocationItem(
            context,
            label: '加油站',
            value: stationName,
            icon: Icons.local_gas_station_outlined,
            emphasize: true,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    bool emphasize = false,
  }) {
    return Column(
      crossAxisAlignment:
          emphasize ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              emphasize ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            // if (!emphasize)
            //   Icon(
            //     icon,
            //     size: AppSizes.setWidth(18),
            //     color: emphasize
            //         ? CustomAppColor.of(context).txtPurple
            //         : CustomAppColor.of(context).txtBlack,
            //   ),
            // SizedBox(width: AppSizes.setWidth(6)),
            Expanded(
              child: CommonText(
                text: value,
                fontSize: AppSizes.setFontSize(14),
                fontWeight: FontWeight.w700,
                textColor: emphasize
                    ? CustomAppColor.of(context).txtPurple
                    : CustomAppColor.of(context).txtBlack,
                textAlign: emphasize ? TextAlign.right : TextAlign.left,
              ),
            ),
            // if (emphasize)
            //   Icon(
            //     icon,
            //     size: AppSizes.setWidth(18),
            //     color: emphasize
            //         ? CustomAppColor.of(context).txtPurple
            //         : CustomAppColor.of(context).txtBlack,
            //   ),
          ],
        ),
        SizedBox(height: AppSizes.setHeight(6)),
        CommonText(
          text: label,
          fontSize: AppSizes.setFontSize(12),
          fontWeight: FontWeight.w500,
          textColor: const Color(0xff6B7280),
          textAlign: emphasize ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildDispatchDetail(BuildContext context, String dispatchDetail) {
    final List<String> lines =
        dispatchDetail.replaceAll('\r\n', '\n').split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.article_outlined,
              size: AppSizes.setWidth(16),
              color: CustomAppColor.of(context).txtGrey,
            ),
            SizedBox(width: AppSizes.setWidth(6)),
            CommonText(
              text: '调度明细',
              fontSize: AppSizes.setFontSize(13),
              fontWeight: FontWeight.w700,
              textColor: CustomAppColor.of(context).txtBlack,
              textAlign: TextAlign.left,
            ),
          ],
        ),
        SizedBox(height: AppSizes.setHeight(8)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.setWidth(12)),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FC),
            borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
            border:
                Border.all(color: CustomAppColor.of(context).containerBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines
                .map(
                  (line) => SelectableText(
                    line.isEmpty ? ' ' : line,
                    style: TextStyle(
                      fontSize: AppSizes.setFontSize(13),
                      color: CustomAppColor.of(context).txtBlack,
                      height: 1.5,
                      // fontFamily: 'monospace',
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final BorderRadius borderRadius =
        BorderRadius.circular(AppSizes.setWidth(12));

    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.setWidth(16),
        right: AppSizes.setWidth(16),
        top: AppSizes.setHeight(12),
        bottom: AppSizes.setHeight(12) + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: CustomAppColor.of(context).white,
              borderRadius: borderRadius,
              child: InkWell(
                borderRadius: borderRadius,
                onTap: () => _handleBack(context),
                child: Container(
                  height: AppSizes.setHeight(52),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                        color: CustomAppColor.of(context).containerBorder),
                  ),
                  child: CommonText(
                    text: '返回',
                    fontSize: AppSizes.setFontSize(15),
                    fontWeight: FontWeight.w600,
                    textColor: CustomAppColor.of(context).txtBlack,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.setWidth(12)),
          Expanded(
            child: Material(
              color: CustomAppColor.of(context).btnPurple,
              borderRadius: borderRadius,
              child: InkWell(
                borderRadius: borderRadius,
                onTap: _isSaving ? null : _saveCertificateImage,
                child: Container(
                  height: AppSizes.setHeight(52),
                  alignment: Alignment.center,
                  child: _isSaving
                      ? SizedBox(
                          width: AppSizes.setWidth(20),
                          height: AppSizes.setWidth(20),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.download_outlined,
                              color: Colors.white,
                              size: AppSizes.setWidth(18),
                            ),
                            SizedBox(width: AppSizes.setWidth(8)),
                            CommonText(
                              text: '保存凭证图片',
                              fontSize: AppSizes.setFontSize(15),
                              fontWeight: FontWeight.w700,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyWithdrawNo(String withdrawNo) async {
    if (withdrawNo == '--') return;
    await Clipboard.setData(ClipboardData(text: withdrawNo));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('提油单号已复制'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleBack(BuildContext context) {
    BaseRouter.pop(context: context, result: true);
    BaseRouter.pop(context: context, result: true);
  }

  String _formatOilAmount(String rawAmount) {
    final double? parsed = double.tryParse(rawAmount);
    if (parsed == null) return rawAmount;
    if (parsed % 1 == 0) {
      return parsed.toStringAsFixed(1);
    }
    return parsed.toStringAsFixed(2);
  }

  String get _dispatchContent {
    final String raw = widget.dispatchInfo;
    if (raw.trim().isNotEmpty) {
      return raw;
    }

    final List<String> lines = [];
    void addLine(String? label, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        lines.add('$label: $value');
      }
    }

    addLine('驾驶员', widget.vehicleModel.driverName);
    addLine('电话', widget.vehicleModel.driverPhone);
    addLine('身份证', widget.vehicleModel.driverIdCard);
    addLine('车号', widget.vehicleModel.plateNumber);
    addLine('车型', widget.vehicleModel.vehicleType);
    addLine('载重', widget.vehicleModel.loadCapacity);

    return lines.isEmpty ? '暂无调度信息' : lines.join('\n');
  }

  Future<void> _saveCertificateImage() async {
    final BuildContext? boundaryContext = _cardKey.currentContext;
    final RenderRepaintBoundary? boundary =
        boundaryContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('暂无法生成图片，请稍后重试'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await Future.delayed(const Duration(milliseconds: 20));
      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('生成图片失败');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final Directory directory = await getTemporaryDirectory();
      final String filePath =
          '${directory.path}/oil_certificate_${DateTime.now().millisecondsSinceEpoch}.png';
      final File file = await File(filePath).create(recursive: true);
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('凭证图片已保存：$filePath'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('保存失败，请重试'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
