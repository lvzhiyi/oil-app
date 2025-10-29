import 'package:oil_business_app/utils/screen.dart';

pt(
  double size, {
  /// pad 缩放比例
  double padScale = 0.625,

  /// 横屏缩放比例
  double landscapeScale = 0.432,

  ///
  bool isPad = false,

  /// 设置文本fontSize
  bool isFontSize = false,
}) {
  double _size = screen.getWidth(
    size,
    padScale: padScale,
    landscapeScale: landscapeScale,
    isPad: isPad,
  );

  return _size;
}

ps(double size) => pt(size, padScale: 1);
