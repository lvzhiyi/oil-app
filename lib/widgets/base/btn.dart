import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/utils/text_util.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SportsIconBtn extends StatelessWidget {
  final Widget? icon;

  final String text;

  final void Function() tapHandle;

  final EdgeInsets? padding;

  final double? fontSize;

  const SportsIconBtn({
    Key? key,
    this.icon,
    required this.text,
    required this.tapHandle,
    this.padding,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tapHandle();
      },
      child: Container(
        padding:
            padding ?? EdgeInsets.symmetric(vertical: pt(3), horizontal: pt(7)),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(200)),
          color: Color(0xffFCDA00),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ?? Container(),
            SizedBox(width: pt(4)),
            Text(
              text,
              style: TextStyle(
                color: const Color(0xff6B430B),
                fontSize: fontSize ?? pt(16, isFontSize: true),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SportsOutLineBtn extends StatelessWidget {
  final Widget? icon;

  final String text;

  final void Function() tapHandle;

  final double? width;

  final double? height;

  final EdgeInsets? padding;

  final double? fontSize;

  final Color? color;

  final Color? borderColor;

  final Color? textColor;

  const SportsOutLineBtn({
    Key? key,
    this.icon,
    required this.text,
    required this.tapHandle,
    this.height,
    this.width,
    this.fontSize,
    this.padding,
    this.color,
    this.borderColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tapHandle();
      },
      child: Container(
        width: width,
        height: height,
        padding:
            padding ?? EdgeInsets.symmetric(vertical: pt(3), horizontal: pt(7)),
        // constraints: BoxConstraints(maxHeight: height ?? pt(30), maxWidth: width ?? pt(90)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? const Color(0xffcdcdcd),
            width: pt(1),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: color ?? Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? const Color(0xffcdcdcd),
            fontSize: fontSize ?? pt(16, isFontSize: true),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class SportsBtn extends StatelessWidget {
  final Widget? icon;

  final String text;

  final void Function() tapHandle;

  final EdgeInsets? padding;

  final double? width;

  final double? height;

  final double? fontSize;

  final FontWeight? fontWeight;

  final Color? color;

  final Color? borderColor;

  final double? borderWidth;

  final Color? fontColor;

  final bool? btnLoading;

  final TDLoadingSize? loadingSize;

  final bool? disabled;

  final bool? feedback;

  final BorderRadius? borderRadius;

  final BoxShadow? boxShadow;

  const SportsBtn(
      {Key? key,
      this.icon,
      required this.text,
      required this.tapHandle,
      this.padding,
      this.height,
      this.width,
      this.fontSize,
      this.color,
      this.borderColor,
      this.borderWidth,
      this.btnLoading,
      this.borderRadius,
      this.fontColor,
      this.fontWeight,
      this.boxShadow,
      this.disabled = false,
      this.feedback = false,
      this.loadingSize = TDLoadingSize.medium})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? const Color(0xffcdcdcd),
          width: borderWidth ?? 0,
        ),
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(pt(8))),
        color: AppColors.darkBlue,
        boxShadow: <BoxShadow>[
          if (disabled == false)
            boxShadow ??
                BoxShadow(
                  color: AppColors.gradientEnd,
                  offset: const Offset(1.1, 1.1),
                  blurRadius: pt(8),
                ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: disabled == true
              ? Colors.transparent
              : Theme.of(context).splashColor,
          borderRadius:
              borderRadius ?? BorderRadius.all(Radius.circular(pt(8))),
          // behavior: HitTestBehavior.translucent,

          onTap: () {
            if (disabled == true || btnLoading == true) return;
            HapticFeedback.lightImpact();
            tapHandle();
          },
          child: Container(
            width: width ?? pt(351),
            height: height ?? pt(52),
            padding: padding ??
                EdgeInsets.symmetric(vertical: pt(3), horizontal: pt(7)),
            // constraints: BoxConstraints(maxHeight: height ?? pt(30), maxWidth: width ?? pt(90)),
            alignment: Alignment.center,

            child: btnLoading == true
                ? TDLoading(
                    size: loadingSize ?? TDLoadingSize.medium,
                    icon: TDLoadingIcon.point,
                    iconColor: TDTheme.of(context).whiteColor1,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      icon ?? Container(),

                      /// 只有传了文本和图标才显示间距，不然会多出一个间距，导致不居中，不美观，所以这里做了判断
                      if (TextUtil.isNotEmpty(text) && icon != null)
                        SizedBox(width: pt(3)),
                      Text(
                        text,
                        style: TextStyle(
                          color: fontColor ?? Colors.white,
                          fontWeight: fontWeight ?? FontWeight.normal,
                          fontSize: fontSize ?? pt(18, isFontSize: true),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SportsAutoBtn extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;
  final double radius;
  final bool? disabled;
  double? horizontalSpace;
  double? verticalSpace;
  final TextStyle textStyle;
  final BoxShadow? boxShadow;
  // ignore: use_key_in_widget_constructors
  SportsAutoBtn(
      {this.horizontalSpace,
      this.verticalSpace,
      this.disabled,
      this.boxShadow,
      required this.buttonText,
      required this.buttonColor,
      required this.onPressed,
      required this.textStyle,
      required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: <BoxShadow>[
          if (disabled == false)
            boxShadow ??
                BoxShadow(
                  color: buttonColor,
                  offset: const Offset(1.1, 1.1),
                  blurRadius: pt(8),
                ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            horizontalSpace ?? pt(12),
            verticalSpace ?? pt(5),
            horizontalSpace ?? pt(12),
            verticalSpace ?? pt(5)),
        child: GestureDetector(
          onTap: onPressed,
          child: Text(buttonText, style: textStyle),
        ),
      ),
    );
  }
}
