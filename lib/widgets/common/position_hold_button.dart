import 'dart:async';

import 'package:flutter/widgets.dart';

/// 悬浮按钮，支持动画显示隐藏
/// PositionHoldButton 是一个可以根据滚动位置显示或隐藏的按钮组件。
///
/// 参数:
/// - [isHold]：初始状态是否显示按钮，默认为 true。
/// - [child]：按钮的子组件。
/// - [bottom]：按钮距离底部的距离。
/// - [right]：按钮距离右侧的距离。
/// - [shouldHiddenBottom]：按钮隐藏时距离底部的距离。
/// - [scrollController]：用于监听滚动事件的 ScrollController。
/// - [duration]：按钮显示或隐藏的动画持续时间，默认为 350 毫秒。
/// - [curve]：动画曲线。
///
/// 方法:
/// - [initState]：初始化状态，设置初始 isHold 值并添加滚动监听器。
/// - [dispose]：销毁时移除滚动监听器。
/// - [scrollListener]：滚动监听器，根据滚动方向和距离决定是否显示或隐藏按钮。
/// - [build]：构建组件，使用 AnimatedPositioned 和 AnimatedOpacity 实现动画效果。
class PositionHoldButton extends StatefulWidget {
  final bool isHold;
  final Widget child;
  final double bottom;
  final double right;
  final double shouldHiddenBottom;
  final ScrollController scrollController;
  final Duration duration;
  final Curve? curve;

  const PositionHoldButton({
    Key? key,
    required this.child,
    required this.bottom,
    required this.right,
    required this.scrollController,
    required this.shouldHiddenBottom,
    this.curve,
    this.isHold = true,
    this.duration = const Duration(milliseconds: 350),
  }) : super(key: key);

  @override
  PositionHoldButtonState createState() => PositionHoldButtonState();
}

class PositionHoldButtonState extends State<PositionHoldButton> {
  bool isHold = true;
  double preOffset = 0;
  int preDirect = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    setState(() {
      isHold = widget.isHold;
    });
    widget.scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(scrollListener);
    timer?.cancel();
    super.dispose();
  }

  /// 停止滑动时开始倒计时展示图标
  void startTime() {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 700), () {
      setState(() {
        isHold = true;
      });
    });
  }

  /// 滚动事件监听
  void scrollListener() {
    double offset = widget.scrollController.offset;
    double maxExtent = widget.scrollController.position.maxScrollExtent;
    bool finalVisible = isHold;
    int direct = preDirect;
    if (offset > preOffset) {
      /// 向下滚动
      direct = 1;
    } else {
      /// 向上滚动
      direct = -1;
    }

    /// 如果向上滑动则展示出来
    if (direct == -1) {
      finalVisible = true;
    }

    /// 如果向下滚动，则隐藏悬浮按钮
    if (direct == 1) {
      finalVisible = false;
    }

    /// 如果滚动到最大滚动底部(距离 - 10)，直接展示展示悬浮按钮
    if (direct == 1 && offset >= maxExtent - 10) {
      finalVisible = true;
    }

    /// 如果滚回顶部，则重新显示按钮
    if (offset <= 0) {
      finalVisible = true;
    }

    /// 滚动方向不同才需要修改滚动方向
    if (direct != preDirect) {
      preDirect = direct;
    }
    preOffset = offset;

    setState(() {
      isHold = finalVisible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      right: widget.right,
      bottom: isHold ? widget.bottom : widget.shouldHiddenBottom,
      curve: isHold ? Curves.easeOutCirc : Curves.easeInCirc,
      duration: const Duration(milliseconds: 350),
      child: AnimatedOpacity(
        opacity: isHold ? 1 : 0,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}
