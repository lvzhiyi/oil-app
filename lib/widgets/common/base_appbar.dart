import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/utils/screen.dart';

// 统一通用的appbar
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    this.title,
    this.widgetTitle,
    Key? key,
    this.onBack,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.leadingOnClick,
    this.backgroundColor = Colors.white,
    this.backIconColor = Colors.black,
    this.mustShowNav = false,
    this.titleColor,
  }) : super(key: key);

  final String? title;
  final Widget? widgetTitle;
  final Widget? leading;
  final void Function()? leadingOnClick;
  final void Function(Function? backHandler)? onBack;
  final bool centerTitle;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color backIconColor;
  final bool mustShowNav; // 强制显示导航栏
  final Color? titleColor;

  @override
  Size get preferredSize {
    return Size.fromHeight(BaseRouter.barHeight + statusHeight);
  }

  //状态栏高度
  double get statusHeight {
    double height = 0;

    return height;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: screen.screenWidth,
          height: statusHeight,
          color: backgroundColor,
        ),
        AppBar(
          automaticallyImplyLeading: true,
          excludeHeaderSemantics: true,
          // 自定义导航栏高度
          toolbarHeight: BaseRouter.barHeight,
          centerTitle: centerTitle,
          titleSpacing: 0,
          backgroundColor: backgroundColor,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          title: widgetTitle ??
              Text(
                title ?? '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: pt(18, isFontSize: true),
                  color: titleColor ?? const Color(0xff000000),
                  fontWeight: FontWeight.bold,
                ),
              ),
          leadingWidth: pt(44),
          leading: Builder(builder: (context) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (leadingOnClick != null) {
                  leadingOnClick!();
                } else {
                  BaseRouter.pop();
                }
              },
              child: leading ??
                  SizedBox(
                    width: pt(44),
                    height: pt(44),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: backIconColor,
                    ),
                  ),
            );
          }),
          actions: actions,
        ),
      ],
    );
  }
}
