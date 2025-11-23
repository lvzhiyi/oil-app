import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class CommonImgUpload extends StatefulWidget {
  final String? hintText;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
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
  late FocusNode _focusNode;

  late TextEditingController _controller;

  XFile? _image;
  String? _imageUrl;

  void _updateImageState() {
    final text = _controller.text;
    if (text.isNotEmpty && text.startsWith('http')) {
      _imageUrl = text;
      _image = null;
    } else if (text.isNotEmpty && !text.startsWith('http')) {
      _image = XFile(text);
      _imageUrl = null;
    } else {
      _image = null;
      _imageUrl = null;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(() {
      setState(() {});
    });
    _controller = widget.controller ?? TextEditingController();

    _controller.addListener(_updateImageState);
    _updateImageState();
  }

  @override
  void didUpdateWidget(CommonImgUpload oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_updateImageState);
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_updateImageState);
      _updateImageState();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateImageState);
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> imagePicker() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (image != null) {
      widget.onChanged?.call(image.path);
      setState(() {
        _image = image;
        _imageUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFocused = _focusNode.hasFocus;
    final hasImage = _image != null || _imageUrl != null;

    final textField = FormBuilderTextField(
      name: widget.name ?? '',
      textAlign: widget.textAlign ?? TextAlign.start,
      textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.top,
      maxLength: widget.maxLength,
      focusNode: _focusNode,
      controller: _controller,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines ?? 1,
      obscureText: false,
      onTap: () {
        if (!hasImage) {
          imagePicker();
        }
      },
      readOnly: true,
      enabled: true,
      style: TextStyle(
        color: (_image != null || _imageUrl != null)
            ? Colors.transparent
            : CustomAppColor.of(context).txtBlack,
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
        hintText: hasImage
            ? ''
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
            : _imageUrl != null
                ? Padding(
                    padding: EdgeInsets.only(
                        left: AppSizes.setWidth(10),
                        top: AppSizes.setHeight(5),
                        bottom: AppSizes.setHeight(5),
                        right: AppSizes.setWidth(17)),
                    child: CachedNetworkImage(
                      imageUrl: _imageUrl!,
                      width: AppSizes.setWidth(126),
                      height: AppSizes.setHeight(126),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: AppSizes.setWidth(126),
                        height: AppSizes.setHeight(126),
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: AppSizes.setWidth(126),
                        height: AppSizes.setHeight(126),
                        color: Colors.grey[200],
                        child: Icon(Icons.error),
                      ),
                    ),
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
        suffixIcon: hasImage
            ? GestureDetector(
                onTap: () {
                  imagePicker();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.setWidth(8),
                    vertical: AppSizes.setHeight(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit,
                        color: CustomAppColor.of(context).borderPurple,
                        size: AppSizes.setFontSize(20),
                      ),
                      SizedBox(width: AppSizes.setWidth(4)),
                      CommonText(
                        text: '编辑',
                        fontSize: AppSizes.setFontSize(14),
                        fontWeight: FontWeight.w500,
                        textColor: CustomAppColor.of(context).borderPurple,
                      ),
                    ],
                  ),
                ),
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
              color:
                  widget.borderColor ?? CustomAppColor.of(context).borderPurple,
              width: 2),
        ),
      ),
    );

    return textField;
  }
}
