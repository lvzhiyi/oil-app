import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/invoice_edit/controller.dart';
import 'package:oil_business_app/pages/invoice_edit/state.dart';

import 'widgets/invoice_edit_form.dart';

class InvoiceEditView extends StatelessWidget {
  final InvoiceEditState state;

  const InvoiceEditView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<InvoiceEditCtrl>();
    return InvoiceEditForm(state: state, controller: ctrl);
  }
}
