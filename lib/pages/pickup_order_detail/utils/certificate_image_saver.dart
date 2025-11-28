import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// 凭证图片保存工具类
///
/// 提供将凭证卡片保存为图片的功能，包括保存到相册、保存到目录和分享
class CertificateImageSaver {
  /// 从 GlobalKey 生成图片字节数据
  ///
  /// [cardKey] 凭证卡片的 RepaintBoundary GlobalKey
  /// [pixelRatio] 图片像素比率，默认为 3
  static Future<Uint8List?> captureImage(
    GlobalKey cardKey, {
    double pixelRatio = 3.0,
  }) async {
    // 等待一帧确保渲染完成
    await Future.delayed(const Duration(milliseconds: 100));

    final BuildContext? boundaryContext = cardKey.currentContext;
    final RenderRepaintBoundary? boundary =
        boundaryContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      throw Exception('无法获取渲染边界');
    }

    final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('生成图片失败');
    }

    return byteData.buffer.asUint8List();
  }

  /// 将图片保存到临时文件
  ///
  /// [bytes] 图片字节数据
  /// 返回临时文件路径
  static Future<String> saveTempFile(Uint8List bytes) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath =
        '${directory.path}/oil_certificate_${DateTime.now().millisecondsSinceEpoch}.png';
    final File file = await File(filePath).create(recursive: true);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  /// 保存图片到相册
  ///
  /// [bytes] 图片字节数据
  /// 返回保存结果，包含文件路径
  static Future<Map<dynamic, dynamic>> saveToGallery(Uint8List bytes) async {
    return await ImageGallerySaverPlus.saveImage(
      bytes,
      quality: 100,
      name: 'oil_certificate_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// 保存图片到用户选择的目录
  ///
  /// [bytes] 图片字节数据
  /// 返回保存的文件路径，如果用户取消则返回 null
  static Future<String?> saveToDirectory(Uint8List bytes) async {
    final String? directoryPath =
        await FilePicker.platform.getDirectoryPath(dialogTitle: '选择保存目录');

    if (directoryPath == null) {
      return null;
    }

    final String filePath =
        '$directoryPath/oil_certificate_${DateTime.now().millisecondsSinceEpoch}.png';
    final File file = await File(filePath).create(recursive: true);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  /// 分享图片
  ///
  /// [filePath] 图片文件路径
  /// [text] 分享文本
  static Future<void> shareImage(String filePath, {String? text}) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath)],
        text: text ?? '提油凭证图片',
      ),
    );
  }
}
