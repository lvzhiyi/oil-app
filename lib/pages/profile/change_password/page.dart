import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/profile/change_password/state.dart';
import 'package:lottery_app/pages/profile/change_password/view.dart';
import 'package:lottery_app/widgets/common/base_page.dart';
import 'controller.dart';

class ProfileChangePasswordPage extends BasePage {
  const ProfileChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileChangePasswordPageState();
}

class _ProfileChangePasswordPageState
    extends BaseState<ProfileChangePasswordPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => ProfileChangePasswordCtrl(),
      child: BlocBuilder<ProfileChangePasswordCtrl, ProfileChangePasswordState>(
        builder: (context, state) {
          return ProfileChangePasswordView(state: state);
        },
      ),
    );
  }
}
