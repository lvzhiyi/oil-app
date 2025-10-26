import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/config/address.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/model/common_type.dart';
import 'package:lottery_app/utils/date_util.dart';
import 'package:lottery_app/widgets/popup/toast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ExportPdf {
  static final ExportPdf _instance = ExportPdf._internal();

  factory ExportPdf() => _instance;

  ExportPdf._internal();

  static exportPdf(List<QrCodeStaticItem> staticCodes) async {
    final pdf = await generatePdf(staticCodes);
    final bytes = await pdf.save();
    final params = ShareParams(
      text: '静态二维码导出',
      files: [XFile.fromData(bytes, mimeType: 'application/pdf')],
    );

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      SportsToast.show(
        '导出成功',
        ToastType.success,
      );
    }
  }

  static Future<pw.PageTheme> myPageTheme(PdfPageFormat format) async {
    final font = await PdfGoogleFonts.notoSansSCMedium();

    return pw.PageTheme(
      pageFormat: format,
      theme: pw.ThemeData.withFont(
        base: font,
        icons: font,
      ),
    );
  }

  /// 生成PDF文档，包含二维码图片和所有静态码信息
  static Future<pw.Document> generatePdf(
      List<QrCodeStaticItem> staticCodes) async {
    final pageTheme = await myPageTheme(PdfPageFormat.a4);
    final pdf = pw.Document();

    // 预先生成所有二维码图片
    final qrImages = <int, Uint8List?>{};
    for (final staticCode in staticCodes) {
      qrImages[staticCode.id] = await _generateQrCodeImage(staticCode);
    }

    // 分页处理：每7行数据为一页
    const rowsPerPage = 7;
    final totalPages = (staticCodes.length / rowsPerPage).ceil();

    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      final startIndex = pageIndex * rowsPerPage;
      final endIndex = (startIndex + rowsPerPage < staticCodes.length)
          ? startIndex + rowsPerPage
          : staticCodes.length;

      final pageStaticCodes = staticCodes.sublist(startIndex, endIndex);

      pdf.addPage(
        pw.Page(
          pageTheme: pageTheme,
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // 页面标题
                  pw.Text(
                    '静态二维码列表 - 第${pageIndex + 1}页',
                    style: const pw.TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    '导出时间: ${formatDateFromMilliSecond(DateTime.now().millisecondsSinceEpoch, format: 'yyyy-MM-dd HH:mm:ss')}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.SizedBox(height: 20),

                  // 二维码表格
                  _buildQrCodeTable(pageStaticCodes, qrImages),
                ],
              ),
            );
          },
        ),
      );
    }

    return pdf;
  }

  /// 构建二维码表格
  static pw.Widget _buildQrCodeTable(
      List<QrCodeStaticItem> staticCodes, Map<int, Uint8List?> qrImages) {
    final tableRows = <pw.TableRow>[];

    // 添加表头
    tableRows.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(
          color: PdfColor(0.9, 0.9, 0.9),
        ),
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              'ID',
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              '二维码链接',
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              '二维码类型',
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              '二维码图片',
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );

    // 添加数据行
    for (final staticCode in staticCodes) {
      tableRows.add(_buildQrCodeTableRow(staticCode, qrImages[staticCode.id]));
    }

    return pw.Table(
      border: pw.TableBorder.all(
        color: const PdfColor(0.8, 0.8, 0.8),
        width: 1,
      ),
      children: tableRows,
    );
  }

  /// 构建二维码表格行
  static pw.TableRow _buildQrCodeTableRow(
      QrCodeStaticItem staticCode, Uint8List? qrImageBytes) {
    return pw.TableRow(
      children: [
        // ID列
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            staticCode.id.toString(),
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
        // 二维码链接列
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            '${BaseAddress.clientBaseUrl}\n?code=${staticCode.uuid}',
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            staticCode.lotteryType.displayName,
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
        // 二维码图片列
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: qrImageBytes != null
              ? pw.Image(
                  pw.MemoryImage(qrImageBytes),
                  width: 60,
                  height: 60,
                )
              : pw.Text(
                  '生成失败',
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PdfColor(0.5, 0.5, 0.5),
                  ),
                ),
        ),
      ],
    );
  }

  /// 生成二维码图片
  static Future<Uint8List?> _generateQrCodeImage(
      QrCodeStaticItem staticCode) async {
    try {
      final qrPainter = QrPainter(
        data: '${BaseAddress.clientBaseUrl}?code=${staticCode.uuid}',
        version: QrVersions.auto,
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        errorCorrectionLevel: QrErrorCorrectLevel.M,
      );

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      qrPainter.paint(canvas, const Size(200, 200));
      final picture = recorder.endRecording();
      final image = await picture.toImage(200, 200);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('生成二维码图片失败: $e');
      return null;
    }
  }
}
