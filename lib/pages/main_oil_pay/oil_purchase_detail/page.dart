import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';
import 'package:oil_business_app/pages/main_oil_pay/oil_purchase_detail/controller.dart';
import 'package:oil_business_app/pages/main_oil_pay/oil_purchase_detail/state.dart';
import 'package:oil_business_app/pages/main_oil_pay/oil_purchase_detail/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

class OilPurchaseDetailPage extends BasePage {
  const OilPurchaseDetailPage({super.key, this.extra});

  final Map<String, dynamic>? extra;

  @override
  State<StatefulWidget> createState() => _OilPurchaseDetailPage();
}

class _OilPurchaseDetailPage extends BaseState<OilPurchaseDetailPage>
    with BasicInitPage {
  @override
  void initState() {
    super.initState();
    // 设置状态栏样式：黑色文字白色背景
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // 黑色图标
      statusBarBrightness: Brightness.light, // iOS 白色背景
    ));
  }

  @override
  Widget body(context) {
    final depot = widget.extra?['depot'] as Depot?;
    if (depot == null) {
      return const Scaffold(
        body: Center(child: Text('油库信息不存在')),
      );
    }

    return BlocProvider(
      create: (BuildContext context) => OilPurchaseDetailCtrl(depot: depot),
      child: BlocBuilder<OilPurchaseDetailCtrl, OilPurchaseDetailState>(
        builder: (context, state) {
          return OilPurchaseDetailView(state: state);
        },
      ),
    );
  }
}
