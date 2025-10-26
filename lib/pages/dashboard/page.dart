import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/dashboard/state.dart';
import 'package:lottery_app/pages/dashboard/view.dart';
import 'package:lottery_app/widgets/common/base_page.dart';

import 'controller.dart';

class DashboardPage extends BasePage {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardPage();
}

class _DashboardPage extends BaseState<DashboardPage> with BasicInitPage {
  @override
  Widget body(context) {
    // 使用从上层传递下来的DashboardCtrl，不再创建新实例
    return BlocBuilder<DashboardCtrl, DashboardState>(
        builder: (context, state) {
      return DashboardView(state: state);
    });
  }
}
