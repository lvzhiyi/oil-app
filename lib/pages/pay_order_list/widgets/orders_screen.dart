import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/pages/pay_order_list/controller.dart';
import 'package:oil_business_app/pages/pay_order_list/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/constant.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/bottom_sheet/bottom_sheet.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';
import 'package:oil_business_app/widgets/base/topbar/topbar.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';
import 'package:oil_business_app/widgets/common/pull_refresh_easy.dart';

import '../../../../../../interfaces/top_bar_click_listener.dart';
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
  bool _isBottomSheetOpen = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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

  void reasonOfCancellation(BuildContext context) {
    customBottomSheet(
      isPaddingRequired: false,
      isDone: false,
      context: context,
      maxHeightRatio: 0.5,
      title: '取消订单',
      content: StatefulBuilder(
        builder: (context, setState) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // Padding(
              //   padding:
              //       EdgeInsets.symmetric(horizontal: AppSizes.setWidth(22)),
              //   child: CommonText(
              //     text: '请选择取消订单的原因',
              //     textColor: CustomAppColor.of(context).txtGrey,
              //     fontSize: AppSizes.setFontSize(15),
              //     fontWeight: FontWeight.w500,
              //     textAlign: TextAlign.start,
              //   ),
              // ),
              SizedBox(height: AppSizes.setHeight(10)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
                child: CommonTextFormField(
                  radius: 6,
                  hintText: '请输入取消订单的原因',
                  hintStyle: TextStyle(
                    color: CustomAppColor.of(context).txtGrey,
                    fontSize: AppSizes.setFontSize(15),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 4,
                ),
              ),
              SizedBox(height: AppSizes.setHeight(10)),
              Container(
                decoration: BoxDecoration(
                  color: CustomAppColor.of(context).bgBlackWhiteScaffold,
                  border: Border(
                    top: BorderSide(
                        color: CustomAppColor.of(context)
                            .txtGrey
                            .withValues(alpha: 0.5)),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.setWidth(22),
                    vertical: AppSizes.setHeight(18)),
                child: CommonButton(
                  height: AppSizes.setHeight(44),
                  radius: 3,
                  btnText: '取消订单',
                  onTap: () {
                    // Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
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
                return OilPageLoading(
                  status: widget.state.pageStatus,
                  child: PullOrRefreshEasy(
                    onRefresh: () async {
                      context.read<PayOrderListCtrl>().onRefresh();
                    },
                    onLoading: () async {
                      context.read<PayOrderListCtrl>().onLoading();
                    },
                    refreshController:
                        context.read<PayOrderListCtrl>().refreshController,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: widget.state.orderList?.length ?? 0,
                      itemBuilder: (context, index) {
                        final order =
                            widget.state.orderList?[index] ?? OrderModel();
                        return _buildOrderCard(order, context);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
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
            if (order.status?.value != OrderStatus.Completed.value)
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
                          reasonOfCancellation(context),
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
                        ignoring: true,
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
                            onTap: () => {}
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
    // TODO: implement onTopBarClick
  }
}
