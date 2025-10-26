import 'package:flutter/material.dart';

class AnimationXListView extends StatefulWidget {
  const AnimationXListView({
    Key? key,
    this.mainScreenAnimationController,
    this.mainScreenAnimation,
    this.height,
    required this.itemCount,
    required this.childBuilder,
  }) : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final int itemCount;
  final double? height;
  final Widget Function(int index) childBuilder;

  @override
  AnimationXListViewState createState() => AnimationXListViewState();
}

class AnimationXListViewState extends State<AnimationXListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? _) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: SizedBox(
              height: widget.height,
              width: double.infinity,
              child: ListView.builder(
                itemCount: widget.itemCount,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      widget.itemCount > 10 ? 10 : widget.itemCount;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return AnimatedBuilder(
                    animation: animationController!,
                    builder: (BuildContext context, Widget? __) {
                      return FadeTransition(
                        opacity: animation,
                        child: Transform(
                          transform: Matrix4.translationValues(
                              100 * (1.0 - animation.value), 0.0, 0.0),
                          child: widget.childBuilder(index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
