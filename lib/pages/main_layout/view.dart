import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/main_layout/state.dart';
import 'widgets/dashboard_screen.dart';

class MainLayoutView extends StatefulWidget {
  final MainLayoutState state;

  const MainLayoutView({super.key, required this.state});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}
