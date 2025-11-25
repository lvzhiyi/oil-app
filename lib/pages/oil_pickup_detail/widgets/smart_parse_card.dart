import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class SmartParseCard extends StatefulWidget {
  final Function(String) onParse;

  const SmartParseCard({Key? key, required this.onParse}) : super(key: key);

  @override
  State<SmartParseCard> createState() => _SmartParseCardState();
}

class _SmartParseCardState extends State<SmartParseCard> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSizes.setWidth(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: '车辆及司机调度信息',
                  fontSize: AppSizes.setFontSize(15),
                  fontWeight: FontWeight.w700,
                  textColor: CustomAppColor.of(context).txtBlack,
                ),
                GestureDetector(
                  onTap: () async {
                    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                    if (clipboardData != null && clipboardData.text != null) {
                      _controller.text = clipboardData.text!;
                      widget.onParse(clipboardData.text!);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.setWidth(10),
                      vertical: AppSizes.setHeight(4),
                    ),
                    decoration: BoxDecoration(
                      color: CustomAppColor.of(context).btnPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.setWidth(4)),
                    ),
                    child: CommonText(
                      text: '点击粘贴',
                      fontSize: AppSizes.setFontSize(12),
                      textColor: CustomAppColor.of(context).btnPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: AppSizes.setWidth(16),
              right: AppSizes.setWidth(16),
              bottom: AppSizes.setWidth(16),
            ),
            child: Column(
              children: [
                Container(
                  height: AppSizes.setHeight(160),
                  padding: EdgeInsets.all(AppSizes.setWidth(12)),
                  decoration: BoxDecoration(
                    color: CustomAppColor.of(context).bgScaffold,
                    borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
                    border: Border.all(
                      color: _hasFocus
                          ? CustomAppColor.of(context).btnPurple
                          : CustomAppColor.of(context).containerBorder,
                      width: 1,
                    ),
                    boxShadow: _hasFocus
                        ? [
                            BoxShadow(
                              color: CustomAppColor.of(context).btnPurple.withValues(alpha: 0.1),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      fontSize: AppSizes.setFontSize(15),
                      color: CustomAppColor.of(context).txtBlack,
                      height: 1.6,
                    ),
                    decoration: InputDecoration(
                      hintText: '请粘贴车牌、司机姓名、电话、身份证号等信息...\n\n示例：\n川A88888\n张三 13800000000\n510100199001011234',
                      hintStyle: TextStyle(
                        fontSize: AppSizes.setFontSize(13),
                        color: CustomAppColor.of(context).txtGrey.withValues(alpha: 0.6),
                        height: 1.6,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (text) {
                      widget.onParse(text);
                    },
                  ),
                ),
                SizedBox(height: AppSizes.setHeight(12)),
                Container(
                  padding: EdgeInsets.all(AppSizes.setWidth(8)),
                  decoration: BoxDecoration(
                    color: CustomAppColor.of(context).txtOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.setWidth(6)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: AppSizes.setHeight(2),
                          right: AppSizes.setWidth(6),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          size: AppSizes.setWidth(12),
                          color: CustomAppColor.of(context).txtOrange,
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          text: '此输入框内文字将直接用于生成提油凭证，请确保信息准确无误。',
                          fontSize: AppSizes.setFontSize(12),
                          textColor: CustomAppColor.of(context).txtOrange,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
