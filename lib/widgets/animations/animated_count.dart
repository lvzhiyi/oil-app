import 'package:flutter/material.dart';

class AnimatedCount extends ImplicitlyAnimatedWidget {
  final int count;
  final Widget Function(String count, Animation<double> animation) countBuilder;
  const AnimatedCount({
    Key? key,
    required this.count,
    required this.countBuilder,
    required Duration duration,
    Curve curve = Curves.linear,
  }) : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedCountState();
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween? _count;

  @override
  Widget build(BuildContext context) {
    return widget.countBuilder(
        _count?.evaluate(animation).toString() ?? '0', animation);
  }

// Text(_count?.evaluate(animation).toString() ?? '0');
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _count = visitor(_count, widget.count,
        (dynamic value) => IntTween(begin: value as int)) as IntTween?;
  }
}
