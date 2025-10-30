import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/main_layout/state.dart';
import 'package:oil_business_app/pages/main_layout/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

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
      ],
      child: BlocBuilder<MainLayoutCtrl, MainLayoutState>(
        builder: (context, state) {
          return MainLayoutView(state: state);
        },
      ),
    );
  }
}
