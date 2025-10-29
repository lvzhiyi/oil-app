import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';

///**
/// 默认输入框
///*/
class DefaultInput extends StatefulWidget {
  const DefaultInput({
    super.key,
    this.showUnderling = true,
    this.hintText,
    this.validators,
    this.obscureText = true,
    this.readOnly = false,
    this.maxLength,
    required this.name,
  });

  ///**
  /// [String] 是否显示下滑线
  /// */
  final String name;

  ///**
  /// [bool] 是否展示输入内容
  /// */
  final bool? showUnderling;

  ///**
  /// [String] 提示文字
  /// */
  final String? hintText;

  final bool? obscureText;

  //是否只读
  final bool? readOnly;

  /// 最大长度
  final int? maxLength;

  ///**
  /// [FormBuilderValidators] 输入验证
  /// */
  final String? Function(String?)? validators;
  @override
  State<DefaultInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<DefaultInput> {
  // bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: FormBuilderTextField(
              readOnly: widget.readOnly == true,
              name: widget.name,
              maxLength: widget.maxLength,
              textAlignVertical: TextAlignVertical.center,
              obscureText: widget.obscureText == true,
              decoration: InputDecoration(
                labelStyle: SportsTextStyle.grayNormal,
                hintText: widget.hintText ?? 'Please Enter ${widget.name}',
                hintStyle: SportsTextStyle.grayNormal,
                enabledBorder: widget.showUnderling == true
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.inputText),
                      )
                    : InputBorder.none,
                focusedBorder: widget.showUnderling == true
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.darkBlue),
                      )
                    : InputBorder.none,
                suffixIcon: Container(
                  width: pt(20),
                  alignment: Alignment.centerRight,
                  child: SvgAsset(
                    assetName: (widget.obscureText == true)
                        ? AssetsSvg.EYE_CLOSE_ICON
                        : AssetsSvg.EYE_FILL_ICON,
                    color: Colors.transparent,
                  ),
                ),
              ),
              validator: widget.validators ??
                  FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: '${widget.name} is required'),
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}
