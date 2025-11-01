import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';

/// UI设计稿的通用弹窗
class SportsDialog {
  static Widget? _getIcon(String? iconUrl, Widget? iconWidget) {
    if (iconUrl == null && iconWidget == null) {
      return null;
    }
    return Container(
      margin: EdgeInsets.only(bottom: pt(12)),
      height: pt(100),
      child: iconWidget ??
          SvgAsset(
            assetName: iconUrl ?? AssetsSvg.LOGO,
            fit: BoxFit.cover,
          ),
    );
  }

  // 具体展示的title部分
  static Widget? _getTitle(String? title, Widget? titleWidget) {
    if (titleWidget == null && title == null) {
      return null;
    }
    return Container(
      padding: EdgeInsets.only(bottom: pt(14), top: pt(14)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: pt(16)),
        child: titleWidget ??
            Text(
              title ?? "",
              softWrap: true,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: pt(18, isFontSize: true),
                fontWeight: FontWeight.w500,
                color: AppColor.txtDarkBlue,
              ),
              overflow: TextOverflow.ellipsis,
            ),
      ),
    );
  }

  static Widget? _getBody(String? bodyText, Widget? bodyWidget) {
    if (bodyText == null && bodyWidget == null) {
      return null;
    }
    return Flexible(
      child: SingleChildScrollView(
        child: bodyWidget ??
            Text(
              textAlign: TextAlign.center,
              bodyText ?? "",
              style: SportsTextStyle.grayNormal,
            ),
      ),
    );
  }

  static Widget? _getFooter(
      String? footerText,
      Widget? footer,
      String? cancelText,
      String? okText,
      void Function()? onCancel,
      void Function()? onOk,
      bool? okLoading) {
    if (footerText != null) {
      // 优先判断footerText,有值就渲染一个按钮
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CommonButton(
              height: pt(42),
              btnText: footerText,
              onTap: () => _handleSingleBtnClick(onOk, onCancel),
            ),
          )
        ],
      );
    }

    List<Widget> children = [];
    if (footer == null) {
      if (onCancel != null) {
        children.add(Expanded(
          child: CommonButton(
            onTap: () => _handleCancel(onCancel),
            btnText: cancelText ?? '',
            height: pt(42),
          ),
        ));

        /// 2个按钮中间才有间隔
        if (onOk != null) {
          children.add(SizedBox(
            width: pt(16),
          ));
        }
      }

      if (onOk != null) {
        children.add(Expanded(
          child: CommonButton(
            onTap: () => _handleOk(onOk),
            btnText: okText ?? '',
            height: pt(48),
          ),
        ));
      }
    }

    if (footer != null) return footer;
    if (children.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }
    // 其次判断footer，最后才渲染【取消】,【确定】双按钮
    return null;
  }

  static void _handleSingleBtnClick(Function? onOk, Function? onCancel) {
    if (onOk != null) {
      onOk();
      return;
    }
    dismiss();
    if (onCancel != null) {
      onCancel();
    }
  }

  static void _handleCancel(Function? onCancel) {
    dismiss();
    if (onCancel != null) {
      onCancel();
    }
  }

  static void _handleOk(Function? onOk) {
    if (onOk != null) {
      onOk();
    } else {
      dismiss();
    }
  }

  static Future<T?> show<T>({
    String? topIcon, // 顶部图片
    Widget? topIconWidget, // 顶部图片组件，会覆盖topIcon
    String? title, // 纯文本title
    Widget? titleWidget, // 自定义title，优先级高于纯文本title
    String? bodyText,
    Widget? body, // 自定义body
    bool clickMaskDismiss = false, // 是否点击遮罩关闭弹窗
    bool showClose = true, // 是否显示右上角的关闭按钮
    String? cancelText = "取消", // 底部取消按钮文案
    String? okText = "确认", // 底部确认按钮文案
    bool okLoading = false, // 底部确认按钮文案
    void Function()? onCancel, // 弹窗关闭执行方法
    void Function()? onOk, // 点击确认按钮执行方法
    bool useAnimation = true, //弹窗显示是否有动画
    bool useSystem = false, // 是否使用系统弹窗
    Widget? footer, // 自定义footer
    String? footerText, // 底部单个按钮文案
    String? tag,
  }) async {
    Widget? renderTopIcon = _getIcon(topIcon, topIconWidget);
    Widget? renderTitle = _getTitle(title, titleWidget);
    Widget? renderBody = _getBody(bodyText, body);
    Widget? renderFooter = _getFooter(
      footerText,
      footer,
      cancelText,
      okText,
      onCancel,
      onOk,
      okLoading,
    );
    var topPadding = (renderTopIcon == null && renderTitle == null && showClose)
        ? pt(52)
        : pt(20);
    return await SmartDialog.show(
      tag: tag,
      useAnimation: useAnimation,
      clickMaskDismiss: clickMaskDismiss,
      useSystem: useSystem,
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Stack(
            children: [
              Container(
                width: pt(336),
                padding: EdgeInsets.fromLTRB(
                  pt(28),
                  topPadding,
                  pt(28),
                  pt(32),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(pt(20)),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (renderTopIcon != null) renderTopIcon,
                    if (renderTitle != null) renderTitle,
                    if (renderBody != null) renderBody,
                    if (renderFooter != null) const Gap(20),
                    if (renderFooter != null) renderFooter,
                  ],
                ),
              ),
              if (showClose)
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: dismiss,
                    child: Container(
                      width: pt(46),
                      height: pt(46),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close,
                        size: pt(20),
                        color: const Color(0xff979797),
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  static Future dismiss() async {
    return await SmartDialog.dismiss();
  }
}
