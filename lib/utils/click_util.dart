/// 点击工具相关
class ClickUtil {
  static DateTime lastClickTime = DateTime(1996);

  ///快速点击
  static bool isFastClick() {
    DateTime dateTime = DateTime.now();

    if (dateTime.difference(lastClickTime) <
        const Duration(milliseconds: 500)) {
      lastClickTime = dateTime;
      return true;
    }
    lastClickTime = dateTime;
    return false;
  }
}
