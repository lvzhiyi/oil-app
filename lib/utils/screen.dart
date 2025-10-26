import 'package:flutter/material.dart';

///  note this;
///  1，对于竖屏操作，这里我们只考虑宽适配，相当于操作16:9->4:3；
///  2，不考虑宽按照宽的比例缩放，高按照高的比例所犯(16:9->4:3伸缩严重)；
///  3，布局中控件/字体中有固定大小的，统一乘以宽的缩放比例，剩余的用弹性布局填充；
///  4，使用之前，请确保_init()函数已经调用；
///  5，布局应该减少相对布局，使用居中布局，方便UI居中显示，和不同宽的两边留白；
///  6, 水平(宽)适配，每个页面应该支持尽量支持高可以滑动 SafeArea + SingleChildScrollView；
///  7，对于没有使用bottomItemBar的页面，如果页面底部有要交互的UI，请加上SafeArea包裹(适应全面屏幕)
///
///class 表示Screen和与之相关的SafeArea

final screen = _Screen();

class _Screen {
  MediaQueryData _mediaQueryData = const MediaQueryData();
  double _screenWidth = .0;
  double _screenHeight = .0;

  /// 设计尺寸
  final designW = 375.0; //DP
  final designH = 780.0; //DP
  final designPadW = 768.0; //ipad设计稿宽度
  var hRate = 1.0; //水平缩放比例
  var vRate = 1.0; //竖直缩放比例，暂时没用
  var hPadRate = 1.0; //水平缩放比例ipad
  var paddingLeft = 0.0;
  var paddingRight = 0.0;
  // 一般为状态栏高度··
  var paddingTop = 0.0;
  //一般为底部操作栏高度
  var paddingBottom = 0.0;
  // 水平安全区域
  var safeHorizontal = 0.0;
  // 垂直安全区域
  var safeVertical = 0.0;
  // 屏幕大小
  Size _screenSize = const Size(.0, .0);

  /// 显示区域高（首页）
  double _displayHeight = .0;

  /// 底部导航栏高度 源码里面写的就是50 dp
  double bottomNavBarH = 50.0;

  /// 加载动画高度
  double loadAnimH = 60;

  /// 页面自定义顶部控件 距离顶部高度
  double _topDistanceH = .0;
  bool _initing = false;
  double devicePixelRatio = 1.0;

  void init([bool? init]) {
    if (_initing && init != true) return;
    _initing = true;
    _mediaQueryData = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    _screenSize = _mediaQueryData.size;
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    paddingLeft = _mediaQueryData.padding.left;
    paddingTop = _mediaQueryData.padding.top;
    paddingRight = _mediaQueryData.padding.right;
    paddingBottom = _mediaQueryData.padding.bottom;
    devicePixelRatio = _mediaQueryData.devicePixelRatio;

    safeHorizontal = paddingLeft + paddingRight;
    safeVertical = paddingTop + paddingBottom;

    if (_screenWidth > 0.1) {
      hRate = _screenWidth / designW;
      vRate = (_screenHeight - safeVertical) / designW;
      hPadRate = (_screenWidth - safeHorizontal) / designPadW;
    }

    _topDistanceH = paddingTop + 10;
    _displayHeight = _screenHeight - paddingBottom - bottomNavBarH;
    _initing = false;
  }

  double get screenWidth {
    return _screenWidth;
  }

  double get screenHeight {
    return _screenHeight;
  }

  bool get isIpad {
    return screenWidth > 480;
  }

  /// convert dp to p
  double c(double dp) {
    return hRate * dp;
  }

  double cPad(double dp) {
    return hPadRate * dp;
  }

  /// @return realDP
  double getWidth(
    double dp, {
    /// pad 缩放比例
    double padScale = 0.625,

    /// 横屏缩放比例
    double landscapeScale = 0.436,

    ///
    bool isPad = false,
  }) {
    // 获取当前设备的屏幕方向
    final orientation = _mediaQueryData.orientation;

    if (orientation == Orientation.landscape) {
      return hRate * dp * landscapeScale;
    }

    // ipad
    if (isPad || screenSize.shortestSide >= 480) {
      return hRate * dp * padScale;
    }

    return hRate * dp;
  }

  /// @return realDP 暂时使用水平适配宽
  double getHeight(double dp) {
    return hRate * dp;
  }

  Size get screenSize {
    return _screenSize;
  }

  double get displayHeight {
    return _displayHeight;
  }

  double get topDistanceH {
    return _topDistanceH;
  }

  Orientation get orientation {
    return _mediaQueryData.orientation;
  }
}
