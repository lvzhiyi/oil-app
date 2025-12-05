import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/global/model/invoice_info.dart';
import 'package:oil_business_app/pages/invoice_edit/state.dart';
import 'package:oil_business_app/pages/invoice_edit/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class InvoiceEditPage extends BasePage {
  const InvoiceEditPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InvoiceEditPageState();
}

class _InvoiceEditPageState extends BaseState<InvoiceEditPage>
    with BasicInitPage {
  @override
  Widget body(context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final stationId = extra?['stationId'] as int? ?? 0;
    final stationName = extra?['stationName'] as String?;

    return BlocProvider(
      create: (BuildContext context) => InvoiceEditCtrl(
        stationId: stationId,
        stationName: stationName,
      ),
      child: BlocBuilder<InvoiceEditCtrl, InvoiceEditState>(
        builder: (context, state) {
          return InvoiceEditView(state: state);
        },
      ),
    );
  }
}
