import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

// 监听元素的隐藏与显示
class VisibilityObserve extends StatefulWidget {
  const VisibilityObserve({
    super.key,
    required this.child,
    required this.onShow,
    this.fraction = 0.8,
    this.once = false,
    this.onHidden,
    this.onClick,
  });

  final Widget child;
  final num fraction; // 触发显示的比例最大值为1
  final bool once; // 监听显示的次数，true 只触发一次
  final void Function() onShow;
  final Function()? onHidden;
  final Function()? onClick;

  @override
  State<VisibilityObserve> createState() => _VisibilityObserveState();
}

class _VisibilityObserveState extends State<VisibilityObserve> {
  UniqueKey key = UniqueKey();
  bool hasShow = false;

  @override
  void dispose() {
    VisibilityDetectorController.instance.forget(key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: key,
      onVisibilityChanged: onVisibilityChanged,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onClick,
        child: widget.child,
      ),
    );
  }

  void onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= widget.fraction && !hasShow) {
      hasShow = true;
      widget.onShow();
    }

    if (info.visibleFraction <= 0.1 && !widget.once) {
      hasShow = false;

      if (widget.onHidden != null) {
        widget.onHidden!();
      }
    }
  }
}
