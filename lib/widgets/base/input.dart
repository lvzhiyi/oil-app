import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/pt.dart';

class SportsInput extends StatefulWidget {
  final FocusNode focusNode;
  final bool? enabled;
  final String? hintText;
  final int? maxLength;
  final void Function(String value)? onSubmitted;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  const SportsInput(
      {Key? key,
      required this.focusNode,
      required this.controller,
      this.enabled,
      this.hintText,
      this.onSubmitted,
      this.maxLength,
      this.keyboardType})
      : super(key: key);

  @override
  State<SportsInput> createState() => _SportsInputState();
}

class _SportsInputState extends State<SportsInput> {
  final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(pt(8)),
    borderSide: const BorderSide(color: Colors.transparent),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (value) {
        widget.onSubmitted!(value);
      },
      maxLength: widget.maxLength,
      controller: widget.controller,
      textInputAction: TextInputAction.done,
      enableSuggestions: false,
      // enableInteractiveSelection: false,
      enabled: widget.enabled ?? true,
      style: const TextStyle(color: Colors.black),
      keyboardType: widget.keyboardType ?? TextInputType.text,
      focusNode: widget.focusNode,
      cursorColor: AppColors.darkBlue,

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        isCollapsed: true,
        contentPadding:
            EdgeInsets.symmetric(horizontal: pt(8), vertical: pt(8)),
        hintText: widget.hintText ?? "请输入您想咨询的问题...",
        hintStyle: TextStyle(
          fontSize: pt(14, isFontSize: true),
          color: const Color(0xff787878),
        ),
        counterText: '',
        border: _outlineInputBorder,
        focusedBorder: _outlineInputBorder,
        enabledBorder: _outlineInputBorder,
        errorBorder: _outlineInputBorder,
        disabledBorder: _outlineInputBorder,
      ),
    );
  }
}
