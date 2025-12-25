import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/main_oil_pay/controller.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';
import 'package:oil_business_app/widgets/common/pull_refresh_easy.dart';

import 'state.dart';
import 'widgets/depots_item.dart';

class MainOilPayView extends StatefulWidget {
  final MainOilPayState state;
  final Map<String, dynamic>? extra;

  const MainOilPayView({super.key, required this.state, this.extra});

  @override
  State<MainOilPayView> createState() => _MainOilPayViewState();
}

class _MainOilPayViewState extends State<MainOilPayView> {
  late EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    // 列表内容
    return Container(
      color: CustomAppColor.of(context).bgTopBar,
      child: OilPageLoading(
        status: state.pageStatus,
        retry: () => context.read<OilPayCtrl>().onRefresh(),
        child: PullOrRefreshEasy(
          refreshController: _refreshController,
          onRefresh: () async {
            context.read<OilPayCtrl>().onRefresh();
            _refreshController.finishRefresh();
          },
          onLoading: () async {
            context.read<OilPayCtrl>().onLoading();
            final currentState = context.read<OilPayCtrl>().state;
            if (currentState.depotList.length >= currentState.total) {
              _refreshController.finishLoad(IndicatorResult.noMore);
            } else {
              _refreshController.finishLoad();
            }
          },
          child: ListView.builder(
            padding: EdgeInsets.all(pt(16)),
            itemCount: state.depotList.length,
            itemBuilder: (context, index) {
              final depot = state.depotList[index];
              return DepotsItemWidget(
                depot: depot,
                onTap: () {
                  BaseRouter.push(
                    context: context,
                    url: AppPage.oilPurchaseDetailPage.path,
                    extra: {'depot': depot},
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
