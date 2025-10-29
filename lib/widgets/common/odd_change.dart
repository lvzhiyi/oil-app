import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/utils/hex_color.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';

class NumberIndicator extends StatefulWidget {
  final String title;
  final double number;
  final double? width;
  final double? height;
  final bool isLocked;
  final double? titleFontSize;
  final Color? titleColor;
  final Color? bgColor;
  final double? radius;
  final bool showBorder;

  const NumberIndicator({
    Key? key,
    required this.title,
    required this.number,
    required this.isLocked,
    this.width,
    this.height,
    this.titleFontSize,
    this.titleColor,
    this.bgColor,
    this.radius,
    this.showBorder = true,
  }) : super(key: key);

  @override
  NumberIndicatorState createState() => NumberIndicatorState();
}

class NumberIndicatorState extends State<NumberIndicator> {
  double _previousNumber = 0;
  bool _showIncreaseIndicator = false;
  bool _showDecreaseIndicator = false;

  @override
  void initState() {
    super.initState();
    _previousNumber = widget.number;
  }

  @override
  void didUpdateWidget(NumberIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.number > _previousNumber) {
      _showIncreaseIndicator = true;
      _showDecreaseIndicator = false;
      _triggerHideIndicator();
    } else if (widget.number < _previousNumber) {
      _showDecreaseIndicator = true;
      _showIncreaseIndicator = false;
      _triggerHideIndicator();
    }
    if (widget.isLocked) {
      _showDecreaseIndicator = false;
      _showIncreaseIndicator = false;
    }
    _previousNumber = widget.number;
  }

  void _triggerHideIndicator() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showIncreaseIndicator = false;
          _showDecreaseIndicator = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius ?? pt(8)),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: widget.width ?? pt(80),
            height: widget.height ?? pt(50),
            decoration: BoxDecoration(
              border: widget.showBorder
                  ? Border.all(color: AppColors.background, width: pt(1))
                  : Border.all(color: Colors.transparent, width: pt(0)),
              borderRadius: BorderRadius.circular(pt(8)),
              color: widget.bgColor ?? Colors.transparent,
            ),
            child: !widget.isLocked
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: pt(widget.titleFontSize ?? 8),
                          color: AppColors.inputText,
                        ),
                      ),
                      Gap(pt(4)),
                      Text(
                        widget.number.toString(),
                        style: TextStyle(
                            fontSize: pt(14),
                            fontWeight: FontWeight.bold,
                            color: widget.titleColor ?? HexColor('#1f1f22')),
                      ),
                    ],
                  )
                : SizedBox(
                    width: pt(22),
                    height: pt(22),
                    child: SvgAsset(
                      assetName: AssetsSvg.LOCK,
                      width: pt(22),
                      color: AppColors.textGray2,
                    ),
                  ),
          ),
          // 绿色标识（右上角）
          if (_showIncreaseIndicator)
            Positioned(
              right: -pt(10),
              top: -pt(10),
              child: Transform.rotate(
                angle: pi / 4, // 45度旋转，角度是以弧度为单位 (pi/4 表示 45°)
                child: Container(
                  width: pt(20),
                  height: pt(20),
                  padding: EdgeInsets.all(pt(4)),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          // 红色标识（右下角）
          if (_showDecreaseIndicator)
            Positioned(
              right: -pt(10),
              bottom: -pt(10),
              child: Transform.rotate(
                angle: pi / 4,
                child: Container(
                  width: pt(20),
                  height: pt(20),
                  padding: EdgeInsets.all(pt(4)),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 用于横向展示
class NumberIndicatorRow extends StatefulWidget {
  final String title;
  final double number;
  final double? width;
  final double? height;
  final bool isLocked;
  final double? titleFontSize;
  final Color? bgColor;
  final Color? titleColor;
  final bool showBorder;

  const NumberIndicatorRow({
    Key? key,
    required this.title,
    required this.number,
    required this.isLocked,
    this.width,
    this.height,
    this.titleFontSize,
    this.bgColor,
    this.showBorder = true,
    this.titleColor,
  }) : super(key: key);

  @override
  NumberIndicatorRowState createState() => NumberIndicatorRowState();
}

class NumberIndicatorRowState extends State<NumberIndicatorRow> {
  double _previousNumber = 0;
  bool _showIncreaseIndicator = false;
  bool _showDecreaseIndicator = false;

  @override
  void initState() {
    super.initState();
    _previousNumber = widget.number;
  }

  @override
  void didUpdateWidget(NumberIndicatorRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.number > _previousNumber) {
      _showIncreaseIndicator = true;
      _showDecreaseIndicator = false;
      _triggerHideIndicator();
    } else if (widget.number < _previousNumber) {
      _showDecreaseIndicator = true;
      _showIncreaseIndicator = false;
      _triggerHideIndicator();
    }
    if (widget.isLocked) {
      _showDecreaseIndicator = false;
      _showIncreaseIndicator = false;
    }
    _previousNumber = widget.number;
  }

  void _triggerHideIndicator() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showIncreaseIndicator = false;
          _showDecreaseIndicator = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(pt(8)),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: widget.width ?? pt(80),
            height: widget.height ?? pt(50),
            padding: EdgeInsets.symmetric(horizontal: pt(12)),
            decoration: BoxDecoration(
              border: widget.showBorder
                  ? Border.all(color: AppColors.background, width: pt(1))
                  : Border.all(color: Colors.transparent, width: pt(0)),
              borderRadius: BorderRadius.circular(pt(8)),
              color: widget.bgColor ?? Colors.transparent,
            ),
            child: !widget.isLocked
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: pt(widget.titleFontSize ?? 12),
                            color: widget.titleColor ?? AppColors.inputText,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gap(pt(4)),
                      Text(
                        widget.number.toString(),
                        style: TextStyle(
                          fontSize: pt(14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    width: pt(22),
                    height: pt(22),
                    child: SvgAsset(
                      assetName: AssetsSvg.LOCK,
                      width: pt(22),
                      color: AppColors.textGray2,
                    ),
                  ),
          ),
          // 绿色标识（右上角）
          if (_showIncreaseIndicator)
            Positioned(
              right: -pt(10),
              top: -pt(10),
              child: Transform.rotate(
                angle: pi / 4, // 45度旋转，角度是以弧度为单位 (pi/4 表示 45°)
                child: Container(
                  width: pt(20),
                  height: pt(20),
                  padding: EdgeInsets.all(pt(4)),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          // 红色标识（右下角）
          if (_showDecreaseIndicator)
            Positioned(
              right: -pt(10),
              bottom: -pt(10),
              child: Transform.rotate(
                angle: pi / 4,
                child: Container(
                  width: pt(20),
                  height: pt(20),
                  padding: EdgeInsets.all(pt(4)),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
