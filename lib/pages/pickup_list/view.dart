import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/interfaces/top_bar_click_listener.dart';
import 'package:oil_business_app/pages/pickup_list/controller.dart';
import 'package:oil_business_app/pages/pickup_list/state.dart';
import 'package:oil_business_app/pages/pickup_list/widgets/pickup_list_item.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/empty_card.dart';
import 'package:oil_business_app/widgets/common/pull_refresh_easy.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';
import 'package:oil_business_app/static/icon.dart';

class PickupListView extends StatefulWidget {
  final PickupListState state;

  const PickupListView({Key? key, required this.state}) : super(key: key);

  @override
  State<PickupListView> createState() => _PickupListViewState();
}

class _PickupListViewState extends State<PickupListView>
    implements TopBarClickListener {

  @override
  void onTopBarClick(String name, {String value = ""}) {
    if (name == 'back') {
      BaseRouter.pop(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<PickupListCtrl>();

    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgTopBar,
      body: SafeArea(
        bottom: true,
        top: false,
        child: Column(
          children: [
            _buildTopBar(context),
            _buildFilterBar(context),
            Expanded(
              child: _buildList(context, ctrl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, PickupListCtrl ctrl) {
    if (widget.state.isLoading && widget.state.orderList.isEmpty) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    if (widget.state.orderList.isEmpty) {
      return PullOrRefreshEasy(
        refreshController: ctrl.refreshController,
        onRefresh: ctrl.onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height - 200,
            alignment: Alignment.center,
            child: EmptyCard(
              desc: '暂无提油订单',
              icon: Image.asset(AssetsIcon.IC_BAG),
            ),
          ),
        ),
      );
    }

    return PullOrRefreshEasy(
      refreshController: ctrl.refreshController,
      onRefresh: ctrl.onRefresh,
      onLoading: ctrl.onLoadMore,
      child: ListView.builder(
        padding: EdgeInsets.all(AppSizes.setWidth(16)),
        itemCount: widget.state.orderList.length,
        itemBuilder: (context, index) {
          final item = widget.state.orderList[index];
          return GestureDetector(
            onTap: () {
              if (item.withdrawId != null || item.id != null) {
                BaseRouter.push(
                  context: context,
                  url: AppPage.pickupOrderDetailPage.path,
                  extra: {
                    'order': item,
                  },
                );
              } else {
                l.w('PickupListView', '订单ID为空，无法跳转到详情页');
                SportsToast.showError('订单信息异常，无法查看详情');
              }
            },
            child: PickupListItem(item: item),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).bgContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.setWidth(16),
            vertical: AppSizes.setHeight(12),
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: CustomAppColor.of(context).containerBorder,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => BaseRouter.pop(context: context),
                child: Container(
                  width: AppSizes.setWidth(32),
                  height: AppSizes.setHeight(32),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back,
                    size: AppSizes.setFontSize(18),
                    color: CustomAppColor.of(context).txtBlack,
                  ),
                ),
              ),
              Expanded(
                child: CommonText(
                  text: '提油订单',
                  fontSize: AppSizes.setFontSize(18),
                  fontWeight: FontWeight.bold,
                  textColor: CustomAppColor.of(context).txtBlack,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: AppSizes.setWidth(32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final ctrl = context.read<PickupListCtrl>();
    final isPendingSelected = widget.state.tabIndex == 0;
    final isCompletedSelected = widget.state.tabIndex == 1;

    return Container(
      color: CustomAppColor.of(context).bgContainer,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(16),
        vertical: AppSizes.setHeight(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterTab(
              context: context,
              label: '待提油',
              isSelected: isPendingSelected,
              onTap: () => ctrl.switchTab(0),
            ),
          ),
          SizedBox(width: AppSizes.setWidth(12)),
          Expanded(
            child: _buildFilterTab(
              context: context,
              label: '已完成',
              isSelected: isCompletedSelected,
              onTap: () => ctrl.switchTab(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = CustomAppColor.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.setHeight(10),
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.btnPurple : colors.bgScaffold,
          borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
        ),
        child: Center(
          child: CommonText(
            text: label,
            fontSize: AppSizes.setFontSize(16),
            fontWeight: FontWeight.w500,
            textColor: isSelected ? colors.white : colors.txtBlack,
          ),
        ),
      ),
    );
  }
}
