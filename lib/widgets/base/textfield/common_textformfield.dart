import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/utils.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

class CommonTextFormField extends StatefulWidget {
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

  const CommonTextFormField({
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
  CommonTextFormFieldState createState() => CommonTextFormFieldState();
}

class CommonTextFormFieldState extends State<CommonTextFormField> {
  bool _obscureText = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.isPasswordField;

    _focusNode.addListener(() {
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
    if (widget.isPhoneNumberField) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          IntlPhoneField(
            disableLengthCheck: true,
            showCursor: false,
            keyboardType: TextInputType.none,
            controller: widget.controller,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppSizes.setFontSize(14),
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              alignLabelWithHint: true,
              labelStyle: TextStyle(
                color: CustomAppColor.of(context).txtGrey,
                fontSize: AppSizes.setFontSize(14),
                fontWeight: FontWeight.w600,
              ),
              fillColor:
                  widget.fillColor ?? CustomAppColor.of(context).bgScaffold,
              filled: true,
              hintText: widget.hintText,
              hintStyle: widget.hintStyle ??
                  TextStyle(
                    color: CustomAppColor.of(context)
                        .txtGrey
                        .withOpacityPercent(0.5),
                  ),
              prefixIcon: widget.leadingIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.leadingIcon,
                    )
                  : null,
              suffixIcon: widget.suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColor.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: widget.borderColor ??
                      CustomAppColor.of(context).borderGrey,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: widget.borderColor ??
                      CustomAppColor.of(context).borderPurple,
                  width: 1.5,
                ),
              ),
            ),
            initialCountryCode: 'CN',
            onChanged: (phone) {
              if (widget.onChanged != null) {
                widget.onChanged!(phone.countryCode);
              }
            },
          ),
          Visibility(
            visible: widget.isCountryLabelVisible ?? false,
            child: Positioned(
              top: -11,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                color:
                    widget.fillColor ?? CustomAppColor.of(context).bgScaffold,
                child: Text(
                  'Country',
                  style: TextStyle(
                    color: CustomAppColor.of(context).txtGrey,
                    fontSize: AppSizes.setFontSize(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return FormBuilderTextField(
        name: widget.name ?? '',
        textAlign: widget.textAlign ?? TextAlign.start,
        textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.top,
        maxLength: widget.maxLength,
        focusNode: _focusNode,
        controller: widget.controller,
        onChanged: widget.onChanged,
        maxLines: widget.maxLines ?? 1,
        obscureText: _obscureText,
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
                  padding:
                      EdgeInsets.symmetric(vertical: AppSizes.setHeight(12)),
                  child: widget.leadingIcon,
                )
              : null,
          suffixIcon: widget.isPasswordField
              ? _obscureText
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Image.asset(
                        AssetsIcon.IC_HIDE,
                        width: AppSizes.setWidth(22),
                        height: AppSizes.setHeight(22),
                      ))
                  : IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: CustomAppColor.of(context).icGrey,
                        weight: AppSizes.setWidth(20),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
              : widget.suffixIcon,
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
                color: widget.borderColor ??
                    CustomAppColor.of(context).borderPurple,
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
}
