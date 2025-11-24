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
  bool _isExpanded = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        border: Border.all(
          color: CustomAppColor.of(context).containerBorder,
          width: 1,
        ),
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
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(AppSizes.setWidth(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.edit_note,
                        size: AppSizes.setWidth(18),
                        color: CustomAppColor.of(context).txtBlue,
                      ),
                      SizedBox(width: AppSizes.setWidth(8)),
                      CommonText(
                        text: '车辆及司机信息',
                        fontSize: AppSizes.setFontSize(14),
                        fontWeight: FontWeight.w700,
                        textColor: CustomAppColor.of(context).txtBlack,
                      ),
                    ],
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: AppSizes.setWidth(20),
                    color: CustomAppColor.of(context).txtGrey,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              padding: EdgeInsets.only(
                left: AppSizes.setWidth(16),
                right: AppSizes.setWidth(16),
                bottom: AppSizes.setWidth(16),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSizes.setWidth(12)),
                    decoration: BoxDecoration(
                      color: CustomAppColor.of(context).bgScaffold,
                      borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
                      border: Border.all(
                        color: CustomAppColor.of(context).containerBorder,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: AppSizes.setFontSize(14),
                        color: CustomAppColor.of(context).txtBlack,
                      ),
                      decoration: InputDecoration(
                        hintText: '粘贴车辆及司机信息',
                        hintStyle: TextStyle(
                          fontSize: AppSizes.setFontSize(13),
                          color: CustomAppColor.of(context).txtGrey.withValues(alpha: 0.6),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                          if (clipboardData != null && clipboardData.text != null) {
                            _controller.text = clipboardData.text!;
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(12)),
                          child: CommonText(
                            text: '粘贴',
                            fontSize: AppSizes.setFontSize(14),
                            textColor: CustomAppColor.of(context).txtBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
