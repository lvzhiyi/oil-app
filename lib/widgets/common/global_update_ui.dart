import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/app_state.dart';

class GlobalUpdateUi extends StatelessWidget {
  final Function(BuildContext context, AppController ctrl) builder;
  const GlobalUpdateUi({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final _globalCtrl = context.read<AppController>();

    return BlocBuilder<AppController, AppState>(builder: (_, state) {
      return builder(context, _globalCtrl);
    });
  }
}
