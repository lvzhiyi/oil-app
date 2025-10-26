import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Curve? curve;
  final Duration? duration;
  const FadeInWidget({
    required Key key,
    required this.child,
    this.curve,
    this.duration,
  }) : super(key: key);

  @override
  FadeInWidgetState createState() => FadeInWidgetState();
}

class FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 200),

      /// 确保在app后台或者屏幕锁屏时，屏幕没刷新时，不再执行动画
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.easeIn,
    );

    /// 触发一次刷新，让VisibilityDetector能立即更新
    /// 确保在初始化时，如果可见，则直接显示
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VisibilityDetectorController.instance.notifyNow();
    });
  }

  @override
  void didUpdateWidget(covariant FadeInWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isVisible) {
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key!,
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.1 && !_isVisible) {
          _isVisible = true;
          _controller.forward();
        }
      },
      child: FadeTransition(
        opacity: _animation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
