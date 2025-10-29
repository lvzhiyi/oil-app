import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/pt.dart';

/// 赛事列表，赛事详情，banner上赔率变化展示动画组件
///
/// 数字 widget 类，用于显示一个数字和一个可动画化的图标(
/// 传入一个数字，如果下次显示的数字比上次显示的数字小，则显示向下的箭头，反之向上)
class NumberWidget extends StatefulWidget {
  /// 要显示的数字
  final double number;

  /// 文本的大小，默认为14
  final double textsize;

  ///  文本的颜色，默认为白色
  final Color textColor;

  ///  文本的字体粗细，默认为正常
  final FontWeight fontWeight;

  const NumberWidget({
    super.key,
    required this.number,
    this.fontWeight = FontWeight.normal,
    this.textsize = 14,
    this.textColor = Colors.white,
  });

  @override
  NumberWidgetState createState() => NumberWidgetState();
}

/// 数字 widget 的状态类
class NumberWidgetState extends State<NumberWidget>
    with TickerProviderStateMixin {
  late AnimationController _upController;
  late AnimationController _downController;
  late Animation<double> _upAnimation;
  late Animation<double> _downAnimation;
  double _previousNumber = 0;
  bool _showIcon = false;
  IconData _iconData = Icons.arrow_drop_up;
  Color _iconColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _upController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _downController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _upAnimation = Tween(begin: 0.0, end: -4.0).animate(
      CurvedAnimation(
        parent: _upController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _downAnimation = Tween(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(
        parent: _downController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _previousNumber = widget.number;
  }

  @override
  void didUpdateWidget(covariant NumberWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      if (widget.number > _previousNumber) {
        setState(() {
          _showIcon = true;
          _iconData = Icons.arrow_drop_up;
          _iconColor = Colors.red;
        });
        _upController.forward(from: 0.0).then((_) {
          _upController.reverse().then((_) {
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                _showIcon = false;
                _iconColor = Colors.white;
              });
            });
          });
        });
      } else if (widget.number < _previousNumber) {
        setState(() {
          _showIcon = true;
          _iconData = Icons.arrow_drop_down;
          _iconColor = Colors.green;
        });
        _downController.forward(from: 0.0).then((_) {
          _downController.reverse().then((_) {
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                _showIcon = false;
                _iconColor = Colors.white;
              });
            });
          });
        });
      }
    }

    _previousNumber = widget.number;
  }

  @override
  void dispose() {
    _upController.dispose();
    _downController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _showIcon
            ? AnimatedBuilder(
                animation: _iconData == Icons.arrow_drop_up
                    ? _upAnimation
                    : _downAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                        0,
                        _iconData == Icons.arrow_drop_up
                            ? _upAnimation.value
                            : _downAnimation.value),
                    child: Icon(
                      _iconData,
                      size: pt(widget.textsize),
                      color: _iconColor,
                    ),
                  );
                },
              )
            : Container(width: pt(0)),
        Text(
          '${widget.number}',
          style: TextStyle(
            fontSize: pt(widget.textsize),
            color: _showIcon ? _iconColor : widget.textColor,
            fontWeight: widget.fontWeight,
            height: 1,
          ),
        ),
      ],
    );
  }
}
