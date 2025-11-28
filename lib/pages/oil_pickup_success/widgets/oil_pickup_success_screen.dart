import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup_success/widgets/bottom_actions.dart';
import 'package:oil_business_app/pages/oil_pickup_success/widgets/receipt_card.dart';
import 'package:oil_business_app/pages/oil_pickup_success/widgets/save_share_sheet.dart';
import 'package:oil_business_app/pages/oil_pickup_success/widgets/success_header.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
    final String dispatchContent = _dispatchContent;

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
      body: _buildBody(horizontalPadding, dispatchContent),
    );
  }

  Widget _buildBody(double horizontalPadding, String dispatchContent) {
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
                      const OilPickupSuccessHeader(),
                      SizedBox(height: AppSizes.setHeight(16)),
                      OilPickupReceiptCard(
                        response: widget.response,
                        inventory: widget.inventory,
                        station: widget.station,
                        oilAmount: widget.oilAmount,
                        dispatchContent: dispatchContent,
                        onCopyWithdrawNo: _copyWithdrawNo,
                        showCopyIcon: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            OilPickupSuccessBottomActions(
              isSaving: _isSaving,
              onBack: () => _handleBack(context),
              onSave: _isSaving ? null : _saveCertificateImage,
            ),
          ],
        ),
        // Hidden widget for image generation
        Positioned(
          left: -10000, // Position off-screen
          top: -10000, // Position off-screen
          child: RepaintBoundary(
            key: _cardKey,
            child: SizedBox(
              width: AppSizes.setWidth(375 - 32),
              child: OilPickupReceiptCard(
                response: widget.response,
                inventory: widget.inventory,
                station: widget.station,
                oilAmount: widget.oilAmount,
                dispatchContent: dispatchContent,
                onCopyWithdrawNo: (_) {},
                showCopyIcon: false, // Hidden for image generation
              ),
            ),
          ),
        ),
      ],
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

  String get _dispatchContent {
    final String raw = widget.dispatchInfo;
    if (raw.trim().isNotEmpty) {
      return raw;
    }

    final List<String> lines = [];
    void addLine(String label, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        lines.add('$label: $value');
      }
    }

    addLine('提油日期', widget.vehicleModel.date);
    addLine('驾驶员', widget.vehicleModel.driverName);
    addLine('电话', widget.vehicleModel.driverPhone);
    addLine('身份证', widget.vehicleModel.driverIdCard);
    addLine('车号', widget.vehicleModel.plateNumber);
    addLine('车型', widget.vehicleModel.vehicleType);
    addLine('载重', widget.vehicleModel.loadCapacity);

    return lines.isEmpty ? '暂无调度信息' : lines.join('\n');
  }

  Future<void> _saveCertificateImage() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

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
      setState(() => _isSaving = false);
      return;
    }

    try {
      await Future.delayed(const Duration(milliseconds: 20));
      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('生成图片失败');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath =
          '${directory.path}/oil_certificate_${DateTime.now().millisecondsSinceEpoch}.png';
      final File file = await File(filePath).create(recursive: true);
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      setState(() => _isSaving = false);
      await _showSaveShareSheet(pngBytes, filePath);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('保存失败，请重试'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      setState(() => _isSaving = false);
    } finally {
      if (mounted && _isSaving) setState(() => _isSaving = false);
    }
  }

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
            await SharePlus.instance.share(
              ShareParams(
                files: [XFile(filePath)],
                text: '提油凭证图片',
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveToGallery(Uint8List bytes) async {
    try {
      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        quality: 100,
        name: 'oil_certificate_${DateTime.now().millisecondsSinceEpoch}',
      );
      final dynamic filePath =
          result['filePath'] ?? result['filePathList']?.first;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            filePath != null ? '已保存到相册 $filePath' : '已保存到相册',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('保存到相册失败，请检查权限'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _saveToDirectory(Uint8List bytes) async {
    try {
      final String? directoryPath =
          await FilePicker.platform.getDirectoryPath(dialogTitle: '选择保存目录');
      if (directoryPath == null) {
        return;
      }
      final String filePath =
          '$directoryPath/oil_certificate_${DateTime.now().millisecondsSinceEpoch}.png';
      final File file = await File(filePath).create(recursive: true);
      await file.writeAsBytes(bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('图片已保存：$filePath'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('保存失败，请重试'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
