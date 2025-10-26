import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery_app/config/address.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/model/common_type.dart';
import 'package:lottery_app/widgets/popup/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

Future<void> exportToExcel(
    BuildContext context, List<QrCodeStaticItem> allData) async {
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];

  List<String> headers = [
    'ID',
    'UUID',
    '创建时间',
    '状态',
    '生成员工',
    '领取链接',
  ];

  for (int i = 0; i < headers.length; i++) {
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        .value = TextCellValue(headers[i]);
  }

  for (int i = 0; i < allData.length; i++) {
    QrCodeStaticItem item = allData[i];
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
        .value = TextCellValue(item.id.toString());
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
        .value = TextCellValue(item.uuid);

    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1))
        .value = TextCellValue(item.createTime.toString());
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1))
        .value = TextCellValue(item.status.name);
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i + 1))
        .value = TextCellValue(item.creatorName);
    sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i + 1))
            .value =
        TextCellValue('${BaseAddress.clientBaseUrl}?code=${item.uuid}');
  }

  var status = await Permission.storage.request();
  if (status.isGranted) {
    String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String filePath =
        '/storage/emulated/0/Download/qr_code_static_export_$formattedDate.xlsx';

    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      final params = ShareParams(
        text: 'Great picture',
        files: [XFile(filePath)],
      );

      final result = await SharePlus.instance.share(params);

      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing the picture!');
      }

      print('File saved at $filePath');
    }
  } else {
    SportsToast.show('导出失败', ToastType.error);
  }
}
