import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

class CommonImgUpload extends StatefulWidget {
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

  const CommonImgUpload({
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
  CommonImgUploadState createState() => CommonImgUploadState();
}

class CommonImgUploadState extends State<CommonImgUpload> {
  bool _obscureText = true;
  late FocusNode _focusNode;

  late TextEditingController _controller;

  XFile? _image;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.isPasswordField;

    _focusNode.addListener(() {
      setState(() {});
    });
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  imagePicker() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      widget.onChanged?.call(image.path);
    }
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isFocused = _focusNode.hasFocus;

    return InkWell(
      onTap: () {
        imagePicker();
      },
      child: FormBuilderTextField(
        name: widget.name ?? '',
        textAlign: widget.textAlign ?? TextAlign.start,
        textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.top,
        maxLength: widget.maxLength,
        focusNode: _focusNode,
        controller: _controller,
        onChanged: widget.onChanged,
        maxLines: widget.maxLines ?? 1,
        obscureText: _obscureText,
        readOnly: true,
        enabled: false,
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
          hintText: _image != null
              ? '点击可重新上传'
              : "${widget.hintText ?? ""}${widget.isRequiredHint ?? false ? " *" : ""}",
          hintStyle: widget.hintStyle ??
              TextStyle(
                  color: CustomAppColor.of(context).hintText,
                  fontWeight: FontWeight.w400,
                  fontSize: AppSizes.setFontSize(14)),
          prefixIcon: _image != null
              ? Padding(
                  padding: EdgeInsets.only(
                      left: AppSizes.setWidth(10),
                      top: AppSizes.setHeight(5),
                      bottom: AppSizes.setHeight(5),
                      right: AppSizes.setWidth(17)),
                  child: Image.file(File(_image!.path),
                      width: AppSizes.setWidth(126),
                      height: AppSizes.setHeight(126)),
                )
              : Padding(
                  padding: EdgeInsets.only(
                      left: AppSizes.setWidth(56),
                      right: AppSizes.setWidth(17)),
                  child: Image.asset(
                    AssetsIcon.IC_CAMERA,
                    height: AppSizes.setHeight(24),
                    width: AppSizes.setWidth(36),
                  ),
                ),
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
      ),
    );
  }
}
