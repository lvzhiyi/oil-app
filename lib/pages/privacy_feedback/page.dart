import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';
import 'controller.dart';
import 'state.dart';
import 'view.dart';

class PrivacyFeedbackPage extends BasePage {
  const PrivacyFeedbackPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PrivacyFeedbackPageState();
}

class _PrivacyFeedbackPageState extends BaseState<PrivacyFeedbackPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (context) => PrivacyFeedbackController(),
      child: BlocBuilder<PrivacyFeedbackController, PrivacyFeedbackState>(
        builder: (context, state) {
          return PrivacyFeedbackView(state: state);
        },
      ),
    );
  }
}
