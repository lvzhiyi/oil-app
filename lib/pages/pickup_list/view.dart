import 'package:easy_refresh/easy_refresh.dart';
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
              child: EasyRefresh(
              controller: ctrl.refreshController,
              header: ClassicHeader(
                showMessage: false,
                showText: true,
                textStyle: TextStyle(
                  fontSize: AppSizes.setFontSize(14),
                  color: CustomAppColor.of(context).txtGrey,
                ),
                dragText: '下拉刷新',
                armedText: '释放刷新',
                readyText: '刷新中...',
                processingText: '刷新中...',
                processedText: '刷新完成',
                failedText: '刷新失败',
                noMoreText: '没有更多了',
                pullIconBuilder: (context, state, __) {
                  return const CupertinoActivityIndicator();
                },
              ),
              footer: ClassicFooter(
                showMessage: false,
                showText: true,
                textStyle: TextStyle(
                  fontSize: AppSizes.setFontSize(14),
                  color: CustomAppColor.of(context).txtGrey,
                ),
                dragText: '上拉加载',
                armedText: '释放加载',
                readyText: '加载中...',
                processingText: '加载中...',
                processedText: '加载完成',
                failedText: '加载失败',
                noMoreText: '没有更多了',
                pullIconBuilder: (context, state, __) {
                  switch (state.result) {
                    case IndicatorResult.noMore:
                      return const Icon(
                        Icons.sentiment_satisfied,
                        size: 16,
                        color: Colors.grey,
                      );
                    case IndicatorResult.fail:
                      return const Icon(
                        Icons.sentiment_very_dissatisfied,
                        size: 16,
                        color: Colors.grey,
                      );
                    default:
                      return const CupertinoActivityIndicator();
                  }
                },
              ),
              onRefresh: () => ctrl.loadData(refresh: true),
              onLoad: () => ctrl.loadData(refresh: false),
              child: widget.state.orderList.isEmpty && !widget.state.isLoading
                  ? EmptyCard(
                      desc: '暂无提油订单',
                      icon: Image.asset(AssetsIcon.IC_BAG),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(AppSizes.setWidth(16)),
                      itemCount: widget.state.orderList.length,
                      itemBuilder: (context, index) {
                        final item = widget.state.orderList[index];
                        return GestureDetector(
                          onTap: () {
                            if (item.id != null) {
                              BaseRouter.push(
                                context: context,
                                url: AppPage.oilPickupDetailPage.path,
                                extra: {
                                  'orderId': item.id!,
                                  'from': 'pickup_list',
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
              ),
            ),
          ],
        ),
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
