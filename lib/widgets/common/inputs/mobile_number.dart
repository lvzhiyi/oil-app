import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/utils/validators.dart' as app_validators;

class MobileNumberInput extends StatelessWidget {
  final String? phoneNumber;
  final bool? readOnly;
  final bool? showUnderling;
  final void Function(String?)? onChanged;
  final void Function()? onEditingComplete;
  final FocusNode? focusNode;
  const MobileNumberInput({
    super.key,
    this.phoneNumber,
    this.readOnly,
    this.onChanged,
    this.showUnderling = true,
    this.focusNode,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FormBuilderTextField(
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
        readOnly: readOnly ?? false,
        initialValue: phoneNumber,
        name: 'phone',
        onChanged: onChanged,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlignVertical: TextAlignVertical.center,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: pt(16), vertical: pt(14)),
          labelStyle: SportsTextStyle.grayNormal,
          filled: true,
          fillColor: const Color(0xFFF8F9FB),
          hintText: '请输入手机号',
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
        validator: app_validators.PhoneValidator.validatePhone,
      ),
    );
  }
}
