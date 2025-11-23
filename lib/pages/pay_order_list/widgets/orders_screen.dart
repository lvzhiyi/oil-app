import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/pages/pay_order_list/controller.dart';
import 'package:oil_business_app/pages/pay_order_list/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/constant.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/topbar/topbar.dart';
import 'package:oil_business_app/widgets/common/empty_card.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';
import 'package:oil_business_app/widgets/common/pull_refresh_easy.dart';

import '../../../../../../interfaces/top_bar_click_listener.dart';
import '../../../router/router.dart';
import '../model/orders_data.dart';

class OrdersScreen extends StatefulWidget {
  final PayOrderListState state;
  const OrdersScreen({super.key, required this.state});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin
    implements TopBarClickListener {
  late TabController _tabController;
  List<String> tabList = [];

  List<ReasonOfCancellationData> reasons = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        print('tabController: ${_tabController.index}');
        final statusArr = [
          null,
          OrderStatus.PendingPayment.value,
          OrderStatus.PaymentUploaded.value,
          OrderStatus.Cancelled.value
        ];
        context
            .read<PayOrderListCtrl>()
            .onRefresh(status: statusArr[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabList = [
      '全部',
      '待支付',
      '已支付',
      '已取消',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgTopBar,
      body: Column(
        children: [
          TopBar(
            this,
            title: '买油订单',
            isShowProfile: false,
            isShowNotification: false,
            isShowLike: false,
            isShowSearchField: false,
            isShowBack: true,
            height: 120,
            isShowCart: false,
            topBarColor: CustomAppColor(context).bgTopBar,
            isShowShadow: false,
            textColor: CustomAppColor.of(context).txtAppBar,
            isShowCartCount: false,
          ),
          _tabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: tabList.map((tab) {
                return _buildList(context);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    final ctrl = context.read<PayOrderListCtrl>();
    
    // Initial Loading
    if (widget.state.pageStatus == PageStatus.loading && widget.state.orderList.isEmpty) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    // Error State
    if (widget.state.pageStatus == PageStatus.error && widget.state.orderList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonText(
              text: '加载失败',
              fontSize: AppSizes.setFontSize(16),
              textColor: CustomAppColor.of(context).txtGrey,
            ),
            SizedBox(height: AppSizes.setHeight(16)),
            CommonButton(
              btnText: '重试',
              width: AppSizes.setWidth(120),
              height: AppSizes.setHeight(40),
              fontSize: AppSizes.setFontSize(14),
              onTap: () => ctrl.onRefresh(),
            ),
          ],
        ),
      );
    }

    // Empty State
    if (widget.state.orderList.isEmpty) {
      return PullOrRefreshEasy(
        refreshController: ctrl.refreshController,
        onRefresh: () => ctrl.onRefresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height - 200,
            alignment: Alignment.center,
            child: EmptyCard(
              desc: '暂无订单',
              icon: Image.asset(AssetsIcon.IC_BAG),
            ),
          ),
        ),
      );
    }

    // List with Pagination
    return PullOrRefreshEasy(
      refreshController: ctrl.refreshController,
      onRefresh: () => ctrl.onRefresh(),
      onLoading: () => ctrl.onLoadMore(),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.state.orderList.length,
        itemBuilder: (context, index) {
          final order = widget.state.orderList[index];
          return _buildOrderCard(order, context);
        },
      ),
    );
  }

  _tabBar() {
    return Container(
      color: CustomAppColor.of(context).icWhite,
      child: TabBar(
        padding: EdgeInsets.zero,
        controller: _tabController,
        labelPadding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(14)),
        isScrollable: false,
        unselectedLabelColor: AppColor.txtGrey,
        labelStyle: TextStyle(
          fontFamily: Constant.fontFamilyUrbanist,
          fontSize: AppSizes.setFontSize(18),
          fontWeight: FontWeight.w500,
        ),
        labelColor: AppColor.txtPurple,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
              width: AppSizes.setWidth(3), color: AppColor.txtPurple),
          insets: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(26)),
        ),
        tabs: tabList.map((tab) {
          return Tab(
            text: tab,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, BuildContext context) {
    final mapOrderIcon = {
      OrderStatus.PendingPayment: AssetsIcon.IC_PENDING,
      OrderStatus.PaymentUploaded: AssetsIcon.IC_PROCESSING,
      OrderStatus.Cancelled: AssetsIcon.IC_CANCELLED,
      OrderStatus.Completed: AssetsIcon.IC_CHECK,
    };
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: AppSizes.setHeight(14), horizontal: AppSizes.setWidth(5)),
        color: CustomAppColor.of(context).bgScaffold,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.setWidth(38)),
                  child: Image.asset(
                    mapOrderIcon[order.status] ?? '',
                    height: AppSizes.setHeight(32),
                    width: AppSizes.setWidth(32),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: order.status?.displayName ?? '',
                      fontWeight: FontWeight.w700,
                      fontSize: AppSizes.setFontSize(15),
                      textColor:
                          _getStatusColor(order.status?.displayName ?? ''),
                    ),
                    SizedBox(height: AppSizes.setWidth(4)),
                    CommonText(
                      text: DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.parse(order.updatedAt ?? '')),
                      fontWeight: FontWeight.w500,
                      fontSize: AppSizes.setFontSize(15),
                      textColor: CustomAppColor.of(context).txtGrey,
                    ),
                    SizedBox(height: AppSizes.setWidth(4)),
                    Row(
                      children: [
                        CommonText(
                          text: '订单号',
                          fontWeight: FontWeight.w500,
                          fontSize: AppSizes.setFontSize(15),
                          textColor: CustomAppColor.of(context).txtGrey,
                        ),
                        SizedBox(width: AppSizes.setWidth(6)),
                        CommonText(
                          text: order.depotId?.toString() ?? '',
                          fontWeight: FontWeight.w500,
                          fontSize: AppSizes.setFontSize(15),
                          textColor: CustomAppColor.of(context).txtGrey,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSizes.setHeight(23)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(12)),
              child: Row(
                children: [
                  SizedBox(width: AppSizes.setWidth(10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              text: order.fuelType ?? '',
                              fontSize: AppSizes.setFontSize(15),
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: AppSizes.setHeight(8)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonText(
                                  text: '价格',
                                  fontSize: AppSizes.setFontSize(15),
                                  fontWeight: FontWeight.w500,
                                  textColor: CustomAppColor.of(context).txtGrey,
                                ),
                                SizedBox(width: AppSizes.setWidth(8)),
                                CommonText(
                                  text:
                                      order.fuelPriceCny?.toStringAsFixed(0) ??
                                          '0',
                                  fontSize: AppSizes.setFontSize(17),
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.setHeight(6)),
                        Row(
                          children: [
                            CommonText(
                              text: '支付方式',
                              fontSize: AppSizes.setFontSize(15),
                              fontWeight: FontWeight.w500,
                              textColor: CustomAppColor.of(context).txtGrey,
                            ),
                            SizedBox(width: AppSizes.setWidth(8)),
                            CommonText(
                              text: '对公转账',
                              fontSize: AppSizes.setFontSize(15),
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.setHeight(6)),
                        Row(
                          children: [
                            CommonText(
                              text: '数量',
                              fontSize: AppSizes.setFontSize(15),
                              fontWeight: FontWeight.w500,
                              textColor: CustomAppColor.of(context).txtGrey,
                            ),
                            SizedBox(width: AppSizes.setWidth(8)),
                            CommonText(
                              text:
                                  order.purchaseTon?.toStringAsFixed(0) ?? '0',
                              fontSize: AppSizes.setFontSize(15),
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.setHeight(10)),
            if (order.status?.value != OrderStatus.Completed.value &&
                order.status?.value != OrderStatus.Cancelled.value)
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.setWidth(15),
                        vertical: AppSizes.setHeight(10)),
                    child: IgnorePointer(
                      ignoring: false,
                      child: CommonButton(
                        height: AppSizes.setHeight(30),
                        width: AppSizes.setWidth(158),
                        radius: 2,
                        borderColor: CustomAppColor.of(context).btnPurple,
                        buttonColor:
                            CustomAppColor.of(context).bgBlackWhiteScaffold,
                        isButtonShadow: true,
                        child: CommonText(
                          text: '取消订单',
                          textColor: CustomAppColor.of(context).txtPurple,
                          fontWeight: FontWeight.w600,
                          fontSize: AppSizes.setFontSize(12),
                        ),
                        onTap: () => {
                          context
                              .read<PayOrderListCtrl>()
                              .reasonOfCancellation(context, order),
                        },
                      ),
                    ),
                  ),
                ),
                if (order.status?.value == OrderStatus.PendingPayment.value)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.setWidth(15),
                          vertical: AppSizes.setHeight(10)),
                      child: IgnorePointer(
                        ignoring: false,
                        child: CommonButton(
                            height: AppSizes.setHeight(30),
                            width: AppSizes.setWidth(158),
                            radius: 2,
                            borderColor: CustomAppColor.of(context).btnPurple,
                            buttonColor: CustomAppColor.of(context).btnPurple,
                            isButtonShadow: true,
                            child: CommonText(
                              text: '去支付',
                              textColor: CustomAppColor.of(context).white,
                              fontWeight: FontWeight.w600,
                              fontSize: AppSizes.setFontSize(12),
                            ),
                            onTap: () => {
                                  BaseRouter.push(
                                    url: AppPage.payOrderDetailPage.path,
                                    extra: {'order': order},
                                  ),
                                }
                            // : Navigator.push(context, TrackOrderScreen.route()),
                            ),
                      ),
                    ),
                  ),
                if (order.status?.value == OrderStatus.PaymentUploaded.value)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.setWidth(15),
                          vertical: AppSizes.setHeight(10)),
                      child: IgnorePointer(
                        ignoring: false,
                        child: CommonButton(
                            height: AppSizes.setHeight(30),
                            width: AppSizes.setWidth(158),
                            radius: 2,
                            borderColor: CustomAppColor.of(context).btnPurple,
                            buttonColor: CustomAppColor.of(context).btnPurple,
                            isButtonShadow: true,
                            child: CommonText(
                              text: '查看详情',
                              textColor: CustomAppColor.of(context).white,
                              fontWeight: FontWeight.w600,
                              fontSize: AppSizes.setFontSize(12),
                            ),
                            onTap: () => {
                                  BaseRouter.push(
                                    url: AppPage.payOrderDetailPage.path,
                                    extra: {'order': order},
                                  ),
                                }
                            // : Navigator.push(context, TrackOrderScreen.route()),
                            ),
                      ),
                    ),
                  ),
              ]),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '待支付':
        return CustomAppColor.of(context).txtPurple;
      case '已取消':
        return CustomAppColor.of(context).red;
      case '已支付':
        return AppColor.containerLightBlue;
      case '已完成':
        return CustomAppColor.of(context).green;

      default:
        return Colors.black;
    }
  }

  @override
  void onTopBarClick(String name, {String value = ""}) {
    if (name == 'back') {
      BaseRouter.pop();
    }
  }
}
