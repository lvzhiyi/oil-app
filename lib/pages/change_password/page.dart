import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/change_password/state.dart';
import 'package:oil_business_app/pages/change_password/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class ChangePasswordPage extends BasePage {
  const ChangePasswordPage({Key? key, this.extra}) : super(key: key);
  final Map<String, dynamic>? extra;

  @override
  State<StatefulWidget> createState() => _ChangePasswordPage();
}

class _ChangePasswordPage extends BaseState<ChangePasswordPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => ChangePasswordCtrl(
        extra: widget.extra,
      ),
      child: BlocListener<ChangePasswordCtrl, ChangePasswordState>(
        listener: (context, state) {
          if (state.changePasswordSuccess) {
            // 使用WidgetsBinding.instance.addPostFrameCallback避免在构建期间导航
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.read<ChangePasswordCtrl>().navigateBack(context);
              }
            });
          }
        },
        child: BlocBuilder<ChangePasswordCtrl, ChangePasswordState>(
          builder: (context, state) {
            return ChangePasswordView(state: state);
          },
        ),
      ),
    );
  }
}



