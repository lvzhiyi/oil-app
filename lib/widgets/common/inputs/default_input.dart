import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/utils/pt.dart';

///**
/// 默认输入框
///*/
class DefaultInput extends StatefulWidget {
  const DefaultInput({
    super.key,
    this.showUnderling = true,
    this.hintText,
    this.validators,
    this.maxLength,
    required this.name,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.initialValue,
  });

  ///**
  /// [String] 是否显示下滑线
  /// */
  final String? name;

  ///**
  /// [bool] 是否展示输入内容
  /// */
  final bool? showUnderling;

  ///**
  /// [String] 提示文字
  /// */
  final String? hintText;

  ///**
  /// [FocusNode] focusNode
  final FocusNode? focusNode;

  ///**
  /// [void Function()] onEditingComplete
  final void Function()? onEditingComplete;

  ///**
  /// [void Function(String?)] onChanged
  final void Function(String?)? onChanged;

  ///**
  /// [String?] initialValue
  final String? initialValue;

  /// 最大长度
  final int? maxLength;

  ///**
  /// [FormBuilderValidators] 输入验证
  /// */
  final String? Function(String?)? validators;
  @override
  State<DefaultInput> createState() => _DefaultInputState();
}

class _DefaultInputState extends State<DefaultInput> {
  // bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FormBuilderTextField(
        focusNode: widget.focusNode,
        onEditingComplete: widget.onEditingComplete,
        initialValue: widget.initialValue,
        name: widget.name ?? 'name',
        onChanged: widget.onChanged,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: pt(16), vertical: pt(14)),
          labelStyle: SportsTextStyle.grayNormal,
          filled: true,
          fillColor: const Color(0xFFF8F9FB),
          hintText: widget.hintText ?? '请输入${widget.name}',
          hintStyle: SportsTextStyle.grayNormal.copyWith(
            color: const Color(0xFFBBBBBB),
            fontSize: pt(16),
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
        validator: widget.validators != null
            ? widget.validators ?? FormBuilderValidators.compose([])
            : FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: '${widget.name}不能为空',
                ),
              ]),
      ),
    );
  }
}
