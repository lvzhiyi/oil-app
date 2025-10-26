import 'package:flutter/material.dart';

/// 自定义图标库
///
/// 来源于 iconfont(assets/fonts)
class SportsIcons {
  /// 全屏展开
  static IconData fullscreen = getIcon(0xe640);

  /// 全屏收起
  static IconData fullscreen_up = getIcon(0xe63f);

  /// 播放
  static IconData play = getIcon(0xe63a);

  /// 暂停
  static IconData pause = getIcon(0xe63b);

  /// 返回
  static IconData back = getIcon(0xe639);

  /// 复制
  static IconData copy = getIcon(0xe649);
}

IconData getIcon(int i) {
  return IconData(
    i,
    fontFamily: 'sportsIcon',
    matchTextDirection: true,
  );
}
