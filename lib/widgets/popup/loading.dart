import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oil_business_app/resources/colors.dart';

enum LoadingType { def }

class SportsLoading {
  static void show({
    BuildContext? context,
    String? msg,
    bool isModal = true,
    EdgeInsetsGeometry? padding,
    Decoration? decoration,
    TextStyle? textStyle,
    Color? backgroundColor,
    double? iconSize,
  }) {
    _Loading.show(
      context: context,
      msg: msg,
      isModal: isModal,
      padding: padding,
      decoration: decoration,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      iconSize: iconSize,
    );
  }

  static void dismiss({BuildContext? context}) {
    _Loading.dismiss(context: context);
  }
}

class _Loading {
  static void show({
    BuildContext? context,
    String? msg,
    bool isModal = true,
    Widget? maskWidget,
    EdgeInsetsGeometry? padding,
    Decoration? decoration,
    TextStyle? textStyle,
    Color? backgroundColor,
    double? iconSize,
  }) {
    SmartDialog.showLoading(
      usePenetrate: !isModal,
      maskWidget: maskWidget ??
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.white.withValues(alpha: 0.5),
            ),
          ),
      builder: (ctx) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CupertinoActivityIndicator(radius: 14),
            const SizedBox(height: 8),
            Text(
              msg ?? '',
              style: textStyle ??
                  const TextStyle(fontSize: 14, color: AppColor.txtGrey),
            ),
          ],
        ),
      ),
    );
  }

  static void dismiss({BuildContext? context}) {
    SmartDialog.dismiss(status: SmartStatus.loading);
  }
}
