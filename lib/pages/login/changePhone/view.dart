import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/pages/login/changePhone/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/utils/screen.dart';
import 'package:oil_business_app/widgets/base/btn.dart';
import 'package:oil_business_app/widgets/base/card.dart';
import 'package:oil_business_app/widgets/common/base_appbar.dart';
import 'package:oil_business_app/widgets/common/inputs/mobile_number.dart';
import 'package:oil_business_app/widgets/common/inputs/verify_code.dart';

import 'controller.dart';

class ChangePhoneView extends HookWidget {
  final Map<String, dynamic> extra;
  final ChangePhoneState state;

  const ChangePhoneView({
    Key? key,
    required this.state,
    required this.extra,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChangePhoneCtrl _ctrl = context.read<ChangePhoneCtrl>();
    final inputList = [
      {
        "lable": 'fields.phone.placeholder',
        "widget": const MobileNumberInput(),
      },
      {
        "lable": 'fields.smsCode.placeholder',
        "widget": VerifyCode(
          formName: "newSmsCode",
          formkey: _ctrl.formKey,
          sence: 'newPhoneNumber',
          showToast: true,
        ),
      },
    ];
    return Scaffold(
      backgroundColor: AppColors.pageBack,
      appBar: const BaseAppBar(
        title: '修改手机号',
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: screen.screenWidth,
          child: FormBuilder(
            key: context.read<ChangePhoneCtrl>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(pt(18)),
                ...List.generate(inputList.length, (index) {
                  final _item = inputList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _item['lable'].toString(),
                        style: SportsTextStyle.baseBold,
                      ),
                      const Gap(8),
                      CardContainer(
                        padding: EdgeInsets.only(left: pt(16), right: pt(16)),
                        child: _item['widget'] as Widget,
                      ),
                      Gap(pt(14)),
                    ],
                  );
                }),
                Gap(pt(30)),
                SportsBtn(
                    btnLoading: _ctrl.state.loading,
                    text: 'index.confirm',
                    tapHandle: () {
                      _ctrl.submit();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
