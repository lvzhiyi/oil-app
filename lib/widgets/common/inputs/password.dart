import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/utils/pt.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    this.showPreIcon = true,
    this.showUnderling = true,
    this.name,
    this.hintText,
    this.maxLength,
    this.minLength,
    this.validator,
    this.focusNode,
    this.autoFocus = false,
  });

  ///**
  /// [String] field name
  ///  */
  final String? name;

  ///**
  /// [int] field name
  ///  */
  final int? maxLength;

  ///**
  /// [int] field name
  ///  */
  final int? minLength;

  ///**
  /// [bool] 是否显示前图标
  ///  */
  final bool? showPreIcon;

  ///**
  /// [bool] 是否显示下滑线
  /// */
  final bool? showUnderling;

  ///**
  /// [String] 提示文字
  /// */
  final String? hintText;

  ///
  /// [FocusNode] focusNode
  final FocusNode? focusNode;

  /// 自动获取焦点
  final bool autoFocus;

  final FormFieldValidator<String>? validator;
  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FormBuilderTextField(
        autofocus: widget.autoFocus,
        focusNode: widget.focusNode,
        name: widget.name ?? 'password',
        textAlignVertical: TextAlignVertical.center,
        obscureText: obscureText,
        maxLines: widget.maxLength ?? 1,
        minLines: widget.minLength ?? 1,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: pt(16), vertical: pt(14)),
          labelStyle: SportsTextStyle.grayNormal,
          filled: true,
          fillColor: const Color(0xFFF8F9FB),
          hintText: widget.hintText ?? '请输入密码',
          hintStyle: SportsTextStyle.grayNormal.copyWith(
            color: const Color(0xFFBBBBBB),
            fontSize: pt(16),
          ),
          counterText: '',
          suffixIcon: Container(
            width: pt(40),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              child: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.primary,
                size: pt(20),
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(pt(12)),
            borderSide: const BorderSide(
              color: Color(0xFFE8E8E8),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(pt(12)),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
        validator: widget.validator != null
            ? widget.validator ?? FormBuilderValidators.compose([])
            : FormBuilderValidators.compose([
                // FormBuilderValidators.required(
                //   errorText: '请输入密码',
                // ),
                // FormBuilderValidators.match(
                //   CommonRegExp.password,
                //   errorText: '密码格式不正确',
                // ),
              ]),
      ),
    );
  }
}
