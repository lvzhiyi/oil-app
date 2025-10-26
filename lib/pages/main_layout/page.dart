import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/pages/dashboard/controller.dart';
import 'package:lottery_app/pages/main_layout/state.dart';
import 'package:lottery_app/pages/main_layout/view.dart';
import 'package:lottery_app/pages/profile/controller.dart';
import 'package:lottery_app/widgets/common/base_page.dart';

import 'controller.dart';

class MainLayoutPage extends BasePage {
  const MainLayoutPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainLayoutPage();
}

class _MainLayoutPage extends BaseState<MainLayoutPage> with BasicInitPage {
  @override
  Widget body(context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainLayoutCtrl()),
        BlocProvider(create: (context) => DashboardCtrl()),
        BlocProvider(
            create: (context) => ProfileCtrl(context.read<AppController>())),
      ],
      child: BlocBuilder<MainLayoutCtrl, MainLayoutState>(
        builder: (context, state) {
          return MainLayoutView(state: state);
        },
      ),
    );
  }
}
