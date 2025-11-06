import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/utils.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

class CommonCityPickerFormField extends StatefulWidget {
  final String? hintText;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final bool isPasswordField;
  final TextEditingController? controller;
  final ValueChanged<String?>? onChanged;
  final bool isPhoneNumberField;
  final Color? fillColor;
  final Color? borderColor;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final int? maxLines;
  final double? radius;
  final String? labelText;
  final Function(String)? onSubmitField;
  final int? maxLength;
  final bool? isRequiredLabel;
  final bool? isRequiredHint;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool? isCountryLabelVisible;
  final String? name;
  final String? Function(String?)? validators;

  const CommonCityPickerFormField({
    super.key,
    this.hintText,
    this.leadingIcon,
    this.isPasswordField = false,
    this.controller,
    this.onChanged,
    this.suffixIcon,
    this.isPhoneNumberField = false,
    this.fillColor,
    this.hintStyle,
    this.focusNode,
    this.borderColor,
    this.maxLines,
    this.labelText,
    this.onSubmitField,
    this.radius = 12,
    this.maxLength,
    this.isRequiredLabel,
    this.isRequiredHint,
    this.textAlign,
    this.textAlignVertical,
    this.isCountryLabelVisible = false,
    this.name,
    this.validators,
  });

  @override
  CommonCityPickerFormFieldState createState() =>
      CommonCityPickerFormFieldState();
}

class CommonCityPickerFormFieldState extends State<CommonCityPickerFormField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(() {
      print('isFocused: $_focusNode');
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFocused = _focusNode.hasFocus;
    print('isFocused: $isFocused');
    return FormBuilderTextField(
      name: widget.name ?? '',
      textAlign: widget.textAlign ?? TextAlign.start,
      textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.top,
      maxLength: widget.maxLength,
      focusNode: _focusNode,
      controller: widget.controller,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines ?? 1,
      readOnly: true,
      style: TextStyle(
        color: CustomAppColor.of(context).txtBlack,
        fontSize: AppSizes.setFontSize(14),
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: isFocused
            ? "${widget.hintText ?? widget.labelText ?? ""}${(widget.isRequiredLabel ?? false) ? " *" : ""}"
            : "${widget.labelText ?? ""}${(widget.isRequiredLabel ?? false) ? " *" : ""}",
        labelStyle: TextStyle(
            color: _focusNode.hasFocus
                ? CustomAppColor.of(context).borderPurple
                : CustomAppColor.of(context).txtGrey,
            fontSize: AppSizes.setFontSize(15),
            fontWeight: FontWeight.w600),
        fillColor: widget.fillColor ?? CustomAppColor.of(context).bgContainer,
        filled: true,
        hintText: isFocused
            ? null
            : "${widget.hintText ?? ""}${widget.isRequiredHint ?? false ? " *" : ""}",
        hintStyle: widget.hintStyle ??
            TextStyle(
                color: CustomAppColor.of(context).hintText,
                fontWeight: FontWeight.w400,
                fontSize: AppSizes.setFontSize(14)),
        prefixIcon: widget.leadingIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(12)),
                child: widget.leadingIcon,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: widget.radius != null
              ? BorderRadius.circular(widget.radius ?? 0)
              : BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.transparent, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: widget.radius != null
              ? BorderRadius.circular(widget.radius ?? 0)
              : BorderRadius.circular(8),
          borderSide: BorderSide(
              color:
                  widget.borderColor ?? CustomAppColor.of(context).borderGrey,
              width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: widget.radius != null
              ? BorderRadius.circular(widget.radius ?? 0)
              : BorderRadius.circular(8),
          borderSide: BorderSide(
              color:
                  widget.borderColor ?? CustomAppColor.of(context).borderPurple,
              width: 2),
        ),
      ),
      validator: widget.validators != null
          ? FormBuilderValidators.compose([widget.validators!])
          : FormBuilderValidators.required(
              errorText: '${widget.name} is required'),
    );
  }
}
