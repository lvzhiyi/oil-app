/// 文件工具类
class FileUtil {
  /// 根据文件扩展名获取 MIME 类型
  ///
  /// [filename] 文件名或文件路径
  /// 返回对应的 MIME 类型，如果无法识别则返回 'image/jpeg'
  static String getContentTypeFromFilename(String filename) {
    final extension = filename.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      case 'svg':
        return 'image/svg+xml';
      case 'ico':
        return 'image/x-icon';
      default:
        return 'image/jpeg';
    }
  }

  /// 获取文件的 MIME 类型
  ///
  /// 优先使用 [mimeType]，如果为 null 则根据文件名判断
  /// [mimeType] XFile 的 mimeType 属性
  /// [filename] 文件名或文件路径
  /// 返回对应的 MIME 类型
  static String getContentType(String? mimeType, String filename) {
    if (mimeType != null && mimeType.isNotEmpty) {
      return mimeType;
    }
    return getContentTypeFromFilename(filename);
  }
}
