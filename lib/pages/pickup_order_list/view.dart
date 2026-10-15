import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/interfaces/top_bar_click_listener.dart';
import 'package:oil_business_app/pages/pickup_order_list/controller.dart';
import 'package:oil_business_app/pages/pickup_order_list/state.dart';
import 'package:oil_business_app/pages/pickup_order_list/widgets/pickup_order_list_item.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/empty_card.dart';
import 'package:oil_business_app/widgets/common/pull_refresh_easy.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/common/image_asset_pro.dart';

class PickupOrderListView extends StatefulWidget {
  final PickupOrderListState state;

  const PickupOrderListView({Key? key, required this.state}) : super(key: key);

  @override
  State<PickupOrderListView> createState() => _PickupOrderListViewState();
}

class _PickupOrderListViewState extends State<PickupOrderListView>
    implements TopBarClickListener {
  @override
  void onTopBarClick(String name, {String value = ""}) {
    if (name == 'back') {
      BaseRouter.pop(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<PickupOrderListCtrl>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildTopBar(context),
          _buildFilterBar(context),
          Expanded(
            child: SafeArea(
              top: false,
              bottom: true,
              child: _buildList(context, ctrl),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, PickupOrderListCtrl ctrl) {
    if (widget.state.isLoading && widget.state.orderList.isEmpty) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    // 网络请求失败时显示错误占位页面
    if (widget.state.errorMessage != null && widget.state.orderList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageAsset(
              assetName: AssetsImg.PAGE_ERROR,
              width: pt(180),
            ),
            SizedBox(height: pt(20)),
            CommonText(
              text: '加载失败',
              fontSize: AppSizes.setFontSize(16),
              textColor: CustomAppColor.of(context).txtGrey,
            ),
            SizedBox(height: pt(16)),
            CommonButton(
              btnText: '刷新',
              width: AppSizes.setWidth(120),
              height: AppSizes.setHeight(40),
              fontSize: AppSizes.setFontSize(14),
              onTap: () => ctrl.onRefresh(),
            ),
          ],
        ),
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
          return PickupOrderListItem(item: item);
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppSizes.setHeight(44),
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: AppSizes.setWidth(8),
                child: GestureDetector(
                  onTap: () => BaseRouter.pop(context: context),
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.setWidth(8)),
                    child: Icon(
                      Icons.arrow_back,
                      size: AppSizes.setFontSize(18),
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
              ),
              CommonText(
                text: '提油订单',
                fontSize: AppSizes.setFontSize(17),
                fontWeight: FontWeight.w600,
                textColor: const Color(0xFF1F2937),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final ctrl = context.read<PickupOrderListCtrl>();
    final isPendingSelected = widget.state.tabIndex == 0;
    final isCompletedSelected = widget.state.tabIndex == 1;
    final isCanceledSelected = widget.state.tabIndex == 2;

    return Container(
      color: CustomAppColor.of(context).white,
      padding: EdgeInsets.only(
        left: AppSizes.setWidth(16),
        right: AppSizes.setWidth(16),
        top: AppSizes.setHeight(8),
        bottom: AppSizes.setHeight(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
        ),
        padding: EdgeInsets.all(AppSizes.setWidth(4)),
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
            Expanded(
              child: _buildFilterTab(
                context: context,
                label: '已完成',
                isSelected: isCompletedSelected,
                onTap: () => ctrl.switchTab(1),
              ),
            ),
            Expanded(
              child: _buildFilterTab(
                context: context,
                label: '已取消',
                isSelected: isCanceledSelected,
                onTap: () => ctrl.switchTab(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.setHeight(8),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.setWidth(6)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: CommonText(
            text: label,
            fontSize: AppSizes.setFontSize(14),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            textColor: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}
