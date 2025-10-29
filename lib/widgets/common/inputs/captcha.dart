import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';

class CaptchaInputs extends StatefulWidget {
  /// 图片节点，如果传了ImageChild，代表手动传入图片和调用获取图形验证码的接口
  /// 如果没传，则自动调用获取图形验证码接口
  final Widget? imageChild;
  final Function()? onImageTap;
  const CaptchaInputs({
    super.key,
    this.imageChild,
    this.onImageTap,
  });

  @override
  State<CaptchaInputs> createState() => CaptchaInputsState();
}

class CaptchaInputsState extends State<CaptchaInputs> {
  @override
  void dispose() {
    super.dispose();
  }

  List<int> buffer = [];

  @override
  void initState() {
    super.initState();
    if (widget.imageChild == null) {
      getCaptcha();
    }
  }

  getCaptcha() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgAsset(
          assetName: AssetsSvg.CAPTCHA,
          width: pt(20),
          height: pt(20),
        ),
        Gap(pt(15)),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: FormBuilderTextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
              ],
              name: 'captcha',
              textAlignVertical: TextAlignVertical.center,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              decoration: InputDecoration(
                labelStyle: SportsTextStyle.grayNormal,
                hintText: '验证码',
                hintStyle: SportsTextStyle.grayNormal,
                suffixIcon: buffer.isNotEmpty || widget.imageChild != null
                    ? GestureDetector(
                        onTap: widget.onImageTap ?? getCaptcha,
                        child: Container(
                          width: pt(75),
                          height: pt(32),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: const Color(0xffe2e2e2)),
                            ),
                            child: widget.imageChild ??
                                Image.memory(Uint8List.fromList(buffer)),
                          ),
                        ),
                      )
                    : Container(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.inputText),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.darkBlue),
                ),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: '请输入验证码'),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
