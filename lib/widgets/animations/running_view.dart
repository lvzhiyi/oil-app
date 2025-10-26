import 'package:flutter/material.dart';

class FadeInView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Widget child;

  const FadeInView(
      {Key? key, this.animationController, this.animation, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? __) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: child,
          ),
        );
      },
    );
  }
}
