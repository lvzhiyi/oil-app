import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  final Widget child;
  final String heroTag;

  const FullImage({Key? key, required this.child, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Hero(
            tag: heroTag,
            child: child,
          ),
        ),
      ),
    );
  }
}
