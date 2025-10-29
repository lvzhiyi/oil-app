import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/profile/state.dart';
import 'package:oil_business_app/pages/profile/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class ProfilePage extends BasePage {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePage();
}

class _ProfilePage extends BaseState<ProfilePage> with BasicInitPage {
  @override
  Widget body(context) {
    // 使用从上层传递下来的ProfileCtrl，不再创建新实例
    return BlocBuilder<ProfileCtrl, ProfileState>(builder: (context, state) {
      return ProfileView(state: state);
    });
  }
}
