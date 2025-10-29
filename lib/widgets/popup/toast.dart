import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';

enum ToastType {
  text,
  success,
  warning,
  error;

  Widget? get icon {
    switch (this) {
      case success:
        // return const Icon(Icons.yard_outlined,
        //     size: 24, color: Color(0xff55CC3D));
        return SvgAsset(
          assetName: AssetsSvg.SUCCESS,
          width: pt(50),
        );
      case warning:
        return SvgAsset(
          assetName: AssetsSvg.WARNING,
          width: pt(50),
        );
      case error:
        return SvgAsset(
          assetName: AssetsSvg.ERROR,
          width: pt(50),
        );
      default:
        return null;
    }
  }
}

class SportsToast {
  static void showText(
    String text, {
    BuildContext? context,
    int duration = 2000,
    EdgeInsetsGeometry? padding,
    Decoration? decoration,
    TextStyle? textStyle,
    Color? backgroundColor,
  }) {
    show(
      text,
      ToastType.text,
      context: context,
      duration: duration,
      padding: padding,
      decoration: decoration,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
    );
  }

  static void showSuccess(
    String text, {
    BuildContext? context,
    int duration = 2000,
    EdgeInsetsGeometry? padding,
    Decoration? decoration,
    TextStyle? textStyle,
    Color? backgroundColor,
  }) {
    show(
      text,
      ToastType.success,
      context: context,
      duration: duration,
      padding: padding,
      decoration: decoration,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
    );
  }

  static void showWarning(
    String text, {
    BuildContext? context,
    int duration = 2000,
    EdgeInsetsGeometry? padding,
    Decoration? decoration,
    TextStyle? textStyle,
    Color? backgroundColor,
    bool? clickMaskDismiss,
  }) {
    show(
      text,
      ToastType.warning,
      context: context,
      duration: duration,
      padding: padding,
      decoration: decoration,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      clickMaskDismiss: clickMaskDismiss,
    );
  }

  static void showError(
    String text, {
    BuildContext? context,
    int duration = 2000,
    EdgeInsetsGeometry? padding,
    Decoration? decoration,
    TextStyle? textStyle,
    Color? backgroundColor,
  }) {
    show(
      text,
      ToastType.error,
      context: context,
      duration: duration,
      padding: padding,
      decoration: decoration,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
    );
  }

  static void show(
    String text,
    ToastType type, {
    BuildContext? context,
    int duration = 2000,
    EdgeInsetsGeometry? padding,
    Decoration? decoration,
    TextStyle? textStyle,
    Color? backgroundColor,
    bool? clickMaskDismiss,
  }) {
    _Toast.show(
      text,
      type,
      context: context,
      duration: duration,
      padding: padding,
      decoration: decoration,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      clickMaskDismiss: clickMaskDismiss,
    );
  }

  static void dismiss({BuildContext? context}) {
    _Toast.dismiss(context: context);
  }
}

class _Toast {
  static void show(
    String text,
    ToastType type, {
    BuildContext? context,
    int duration = 2000,
    EdgeInsetsGeometry? padding,
    Decoration? decoration,
    TextStyle? textStyle,
    Color? backgroundColor,
    bool? clickMaskDismiss,
  }) {
    /// 由于自带的toast的mask做了特殊处理，自己build自定义样式添加的mask无法做点击不穿透处理，所以这里直接改用show来模拟toast
    SmartDialog.show(
      alignment: Alignment.center,
      displayTime: Duration(milliseconds: duration),
      maskColor: Colors.transparent,
      clickMaskDismiss: clickMaskDismiss ?? false,
      builder: (ctx) => _ToastBody(
        text,
        type: type,
        padding: padding,
        decoration: decoration,
        textStyle: textStyle,
        backgroundColor: backgroundColor,
      ),
    );
  }

  static void dismiss({BuildContext? context}) {
    SmartDialog.dismiss(status: SmartStatus.toast);
  }
}

class _ToastBody extends StatelessWidget {
  const _ToastBody(
    this.text, {
    Key? key,
    this.type,
    this.padding,
    this.decoration,
    this.textStyle,
    this.backgroundColor,
  }) : super(key: key);

  final String text;
  final ToastType? type;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    var fStyle = textStyle ??
        TextStyle(
          fontSize: pt(12),
          color: AppColors.inputText,
          fontFamily: "PingFangSC",
          decoration: TextDecoration.none,
        );
    var fColor = backgroundColor ?? Colors.white;
    var fDecoration = decoration ??
        BoxDecoration(
          color: fColor,
          borderRadius: BorderRadius.all(Radius.circular(pt(10))),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffACB2BB),
              offset: Offset(pt(4), pt(7)),
              spreadRadius: 0,
              blurRadius: pt(15),
            )
          ],
        );
    var fPadding =
        padding ?? EdgeInsets.symmetric(horizontal: pt(20), vertical: pt(12));
    var fMargin = EdgeInsets.symmetric(horizontal: pt(20), vertical: pt(12));

    Widget getChildRender() {
      if (type?.icon == null) {
        return Text(text, style: fStyle);
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          type?.icon ?? Container(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: fStyle,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      );
    }

    return Container(
      margin: fMargin,
      decoration: fDecoration,
      padding: fPadding,
      child: getChildRender(),
    );
  }
}
