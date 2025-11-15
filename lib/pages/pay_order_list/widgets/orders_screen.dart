import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/constant.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/bottom_sheet/bottom_sheet.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/topbar/topbar.dart';

import '../../../../../../interfaces/top_bar_click_listener.dart';
import '../model/orders_data.dart';

class OrdersScreen extends StatefulWidget {
  final bool isForReasonOfCancellationBs;
  final bool isForOrderCancelBs;
  const OrdersScreen(
      {super.key,
      this.isForOrderCancelBs = false,
      this.isForReasonOfCancellationBs = false});
  static Route route(
      {bool isForReasonOfCancellationBs = false,
      bool isForOrderCancelBs = false}) {
    return MaterialPageRoute(
        builder: (context) => OrdersScreen(
              isForOrderCancelBs: isForOrderCancelBs,
              isForReasonOfCancellationBs: isForReasonOfCancellationBs,
            ));
  }

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin
    implements TopBarClickListener {
  late TabController _tabController;
  List<String> tabList = [];

  List<OrderModel> orders = [];

  List<ReasonOfCancellationData> reasons = [];
  bool _isBottomSheetOpen = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    if (widget.isForReasonOfCancellationBs) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showReasonOrderCancelBS();
      });
    }
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

  void fillData() {
    orders = [
      OrderModel(
        status: '已支付',
        date: '2025-01-01',
        orderId: '1234567890',
        productName: '商品名称',
        iconUrl: AssetsIcon.IC_CHECK,
        price: 299.0,
        paymentMode: "COD",
        size: "M",
        quantity: 1,
        imageUrl: '',
        actions: ['取消订单'],
      ),
      OrderModel(
        status: '已支付',
        date: '2025-01-01',
        orderId: '1234567890',
        productName: '商品名称',
        iconUrl: AssetsIcon.IC_CHECK,
        price: 299.0,
        paymentMode: "COD",
        size: "M",
        quantity: 1,
        imageUrl: '',
        actions: ['取消订单'],
      ),
      OrderModel(
        status: '已支付',
        date: '2025-01-01',
        orderId: '1234567890',
        productName: '商品名称',
        iconUrl: AssetsIcon.IC_CLOSE_SQUARE,
        price: 299.0,
        paymentMode: "COD",
        size: "M",
        quantity: 1,
        imageUrl: '',
        actions: ['取消订单'],
      ),
      OrderModel(
        status: '已支付',
        date: '2025-01-01',
        orderId: '1234567890',
        productName: '商品名称',
        iconUrl: AssetsIcon.IC_CLOSE_SQUARE,
        price: 299.0,
        paymentMode: "COD",
        size: "M",
        quantity: 1,
        imageUrl: '',
        actions: ['取消订单'],
      ),
      OrderModel(
        status: '已支付',
        date: '2025-01-01',
        orderId: '1234567890',
        productName: '商品名称',
        iconUrl: AssetsIcon.IC_CLOSE_SQUARE,
        price: 299.0,
        paymentMode: "COD",
        size: "M",
        quantity: 1,
        imageUrl: '',
      ),
      OrderModel(
        status: '已支付',
        date: '2025-01-01',
        orderId: '1234567890',
        productName: '商品名称',
        iconUrl: AssetsIcon.IC_CLOSE_SQUARE,
        price: 299.0,
        paymentMode: "COD",
        size: "M",
        quantity: 1,
        imageUrl: '',
        actions: ['取消订单'],
      ),
    ];
  }

  void showReasonOrderCancelBS() {
    setState(() {
      _isBottomSheetOpen = true;
    });
    String? selectedReason;

    customBottomSheet(
      isPaddingRequired: false,
      isDone: false,
      context: context,
      title: '取消原因'.toUpperCase(),
      content: StatefulBuilder(
        builder: (context, setState) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.setWidth(22)),
                child: const CommonText(
                  text: '请告诉我们正确的取消原因',
                  textColor: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSizes.setHeight(10)),
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.grey,
                  radioTheme: RadioThemeData(
                    fillColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        return states.contains(WidgetState.selected)
                            ? CustomAppColor.of(context).txtPurple
                            : CustomAppColor.of(context).txtGrey;
                      },
                    ),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
                  child: Column(
                    children: reasons.map((reason) {
                      return RadioListTile<String>(
                        title: CommonText(
                          text: reason.reason,
                          textColor: CustomAppColor.of(context).txtGrey,
                          textAlign: TextAlign.start,
                        ),
                        value: reason.reason,
                        groupValue: selectedReason,
                        onChanged: (String? value) {
                          setState(() {
                            // This updates the state inside the bottom sheet
                            selectedReason = value;
                          });
                        },
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
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
                child: IgnorePointer(
                  ignoring: true,
                  child: CommonButton(
                    height: AppSizes.setHeight(44),
                    radius: 3,
                    btnText: '取消',
                    onTap: () {
                      // Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ).whenComplete(() {
      if (_isBottomSheetOpen) {
        setState(() {
          _isBottomSheetOpen = false;
        });
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    fillData();
    return PopScope(
      canPop: !_isBottomSheetOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isBottomSheetOpen) {
          Navigator.pop(context);
          setState(() {
            _isBottomSheetOpen = false;
          });
          Navigator.pop(context);
        }
      },
      child: Scaffold(
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
                  if (tab == '全部') {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return _buildOrderCard(order, context);
                      },
                    );
                  } else if (tab == '待支付') {
                    final pendingOrders =
                        orders.where((order) => order.status == '待支付').toList();

                    if (pendingOrders.isEmpty) {
                      return Center(
                        child: _emptyHistory(context),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: pendingOrders.length,
                      itemBuilder: (context, index) {
                        final order = pendingOrders[index];
                        return _buildOrderCard(order, context);
                      },
                    );
                  } else if (tab == '已支付') {
                    final pendingOrders =
                        orders.where((order) => order.status == '已支付').toList();

                    if (pendingOrders.isEmpty) {
                      return Center(
                        child: _emptyHistory(context),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: pendingOrders.length,
                      itemBuilder: (context, index) {
                        final order = pendingOrders[index];
                        return _buildOrderCard(order, context);
                      },
                    );
                  } else if (tab == '已取消') {
                    final deliveredOrder =
                        orders.where((order) => order.status == '已取消').toList();

                    if (deliveredOrder.isNotEmpty) {
                      return Center(
                        child: _emptyHistory(context),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: deliveredOrder.length,
                      itemBuilder: (context, index) {
                        final order = deliveredOrder[index];
                        return _buildOrderCard(order, context);
                      },
                    );
                  } else {
                    return Center(
                      child: SingleChildScrollView(
                        child: _emptyHistory(context),
                      ),
                    );
                  }
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return Container(
      color: CustomAppColor.of(context).icWhite,
      child: TabBar(
        padding: EdgeInsets.zero,
        controller: _tabController,
        tabAlignment: TabAlignment.start,
        labelPadding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(14)),
        isScrollable: true,
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
                    order.iconUrl,
                    height: AppSizes.setHeight(32),
                    width: AppSizes.setWidth(32),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: order.status,
                      fontWeight: FontWeight.w700,
                      fontSize: AppSizes.setFontSize(15),
                      textColor: _getStatusColor(order.status),
                    ),
                    SizedBox(height: AppSizes.setWidth(4)),
                    CommonText(
                      text: order.date,
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
                          text: order.orderId,
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
                              text: '商品名称',
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
                                  text: "${order.price}",
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
                              text: order.paymentMode,
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
                              text: order.quantity.toString(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: (order.actions ?? []).isNotEmpty
                  ? order.actions!
                      .map((action) => Expanded(
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
                                    borderColor:
                                        CustomAppColor.of(context).btnPurple,
                                    buttonColor:
                                        CustomAppColor.of(context).btnPurple,
                                    isButtonShadow: true,
                                    child: CommonText(
                                      text: action.toUpperCase(),
                                      textColor:
                                          CustomAppColor.of(context).white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppSizes.setFontSize(12),
                                    ),
                                    onTap: () => {}
                                    // : Navigator.push(context, TrackOrderScreen.route()),
                                    ),
                              ),
                            ),
                          ))
                      .toList()
                  : [],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Order Confirmed":
        return CustomAppColor.of(context).green;
      case "Order Cancelled":
        return CustomAppColor.of(context).red;
      case "Order Processing":
        return AppColor.containerLightBlue;
      case "Order Delivered":
        return CustomAppColor.of(context).green;
      case "Order Pending":
        return AppColor.orange;
      case "Order Dispatched":
        return AppColor.txtDarkBlue;
      default:
        return Colors.black;
    }
  }

  Widget _emptyHistory(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AssetsImg.IMG_EMPTY_ORDER,
          height: AppSizes.setHeight(208),
          width: AppSizes.setWidth(250),
        ),
        SizedBox(height: AppSizes.setHeight(24)),
        CommonText(
          text: '订单历史为空',
          fontWeight: FontWeight.w700,
          fontSize: AppSizes.setFontSize(15),
        ),
        SizedBox(height: AppSizes.setHeight(10)),
        CommonText(
          text: '添加商品到购物车',
          fontWeight: FontWeight.w500,
          fontSize: AppSizes.setFontSize(12),
          textColor: CustomAppColor.of(context).txtGrey,
        ),
        SizedBox(height: AppSizes.setHeight(24)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(22)),
          child: CommonButton(
            radius: 3,
            height: AppSizes.setHeight(44),
            btnText: '去买油',
          ),
        )
      ],
    );
  }

  @override
  void onTopBarClick(String name, {String value = ""}) {
    // TODO: implement onTopBarClick
  }
}
