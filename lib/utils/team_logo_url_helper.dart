// lib/utils/url_helper.dart

import 'package:oil_business_app/config/config.dart';

// 根据环境配置选择基础URL
// 在生产环境中使用https://d304ddif59eis.cloudfront.net/pic/
// 在非生产环境中使用https://dp6ud419ydcvn.cloudfront.net/pic/
String _TeamLogoBaseUrl = BaseConfig.share.isProduction
    ? "https://d304ddif59eis.cloudfront.net/pic/"
    : 'https://dp6ud419ydcvn.cloudfront.net/pic/';

/// 根据给定的ID生成图片的URL
///
/// @param {id} 图片的ID，用于定位特定的图片文件
/// @return 返回构造的图片URL字符串
String getImageUrl(int? id) {
  return "$_TeamLogoBaseUrl$id.png";
}
