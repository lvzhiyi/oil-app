import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/base/btn.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class VerifyCode extends StatefulWidget {
  final bool? showUnderling;

  ///**
  /// [bool] 是否显示前图标
  ///  */
  final bool? showPreIcon;

  final bool? isNoPhone;

  final String? hintText;

  final String? formName;

  final bool? showToast;

  final Future<void> Function()? callback;

  ////**
  /// [sendHandle] 发送后的回调
  ///  */
  final void Function(bool? isRegister)? sendHandle;

  /// 发送前的回调，只有在返回true的时候才会发送
  final Future<bool> Function()? beforeSend;

  final GlobalKey<FormBuilderState> formkey;
  final String sence;
  const VerifyCode({
    super.key,
    this.showUnderling = true,
    this.showPreIcon = true,
    this.sendHandle,
    this.isNoPhone = false,
    this.hintText,
    this.formName,
    this.callback,
    this.showToast,
    this.beforeSend,
    required this.formkey,
    required this.sence,
  });

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool isSending = false;
  bool isLoading = false;
  int count = 60;
  Timer? _timer;

  send() async {
    if (isSending || isLoading) return;
    if (widget.isNoPhone == null || widget.isNoPhone == false) {
      final isValid = widget.formkey.currentState?.fields['phone']?.validate();
      if (isValid != true) return;
    }
    bool canSendSms = true;
    if (widget.beforeSend != null) {
      canSendSms = await widget.beforeSend!();
    }
    if (canSendSms == false) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    setState(() {
      isLoading = false;
      isSending = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        count--;
      });
      if (count == 0) {
        _timer?.cancel();
        setState(() {
          isSending = false;
          count = 60;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.showPreIcon == true)
          SvgAsset(
            assetName: AssetsSvg.SMSCODE,
            width: pt(16),
            height: pt(18),
          ),
        if (widget.showPreIcon == true) Gap(pt(15)),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: FormBuilderTextField(
              name: widget.formName ?? 'smsCode',
              textAlignVertical: TextAlignVertical.center,
              maxLength: 4,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              decoration: InputDecoration(
                counterText: '',
                labelStyle: SportsTextStyle.grayNormal,
                hintText: widget.hintText ?? '验证码',
                hintStyle: SportsTextStyle.grayNormal,
                suffixIcon: Container(
                  width: pt(75),
                  alignment: Alignment.centerLeft,
                  child: SportsBtn(
                    text: isSending ? '${count}s' : 'Send',
                    tapHandle: send,
                    width: pt(75),
                    height: pt(32),
                    fontSize: pt(14),
                    btnLoading: isLoading,
                    loadingSize: TDLoadingSize.small,
                  ),
                ),
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
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: '请输入正确的验证码'),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
