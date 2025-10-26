import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/employee_management/state.dart';
import 'package:lottery_app/pages/employee_management/view.dart';
import 'package:lottery_app/widgets/common/base_page.dart';

import 'controller.dart';

class EmployeeManagementPage extends BasePage {
  const EmployeeManagementPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmployeeManagementPage();
}

class _EmployeeManagementPage extends BaseState<EmployeeManagementPage>
    with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => EmployeeManagementCtrl(),
      child: BlocBuilder<EmployeeManagementCtrl, EmployeeManagementState>(
        builder: (context, state) {
          return EmployeeManagementView(state: state);
        },
      ),
    );
  }
}
