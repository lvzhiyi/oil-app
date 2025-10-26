import 'package:flutter/material.dart';

class BaseDesignIcons {
  /// 订阅
  // static IconData bell = getIcon(0xe681);
}

IconData getIcon(int i) {
  return IconData(
    i,
    matchTextDirection: true,
    fontPackage: '',
  );
}
