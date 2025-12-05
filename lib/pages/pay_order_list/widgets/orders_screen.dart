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
import 'package:oil_business_app/utils/fuel_type_helper.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';
import 'package:oil_business_app/widgets/common/pull_refresh_easy.dart';
import '../../../router/router.dart';
import '../model/orders_data.dart';

class OrdersScreen extends StatefulWidget {
  final PayOrderListState state;
  const OrdersScreen({super.key, required this.state});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF1F2937),
            size: AppSizes.setWidth(20),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: CommonText(
          text: '买油订单',
          fontWeight: FontWeight.w600,
          fontSize: AppSizes.setFontSize(17),
          textColor: const Color(0xFF1F2937),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
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

    // 使用 BlocBuilder 监听状态变化，确保切换 tab 时能正确更新
    return BlocBuilder<PayOrderListCtrl, PayOrderListState>(
      builder: (context, state) {
        // Initial Loading
        if (state.pageStatus == PageStatus.loading && state.orderList.isEmpty) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        // Error State
        if (state.pageStatus == PageStatus.error && state.orderList.isEmpty) {
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
        if (state.orderList.isEmpty) {
          return PullOrRefreshEasy(
            refreshController: ctrl.refreshController,
            onRefresh: () => ctrl.onRefresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: AppSizes.setHeight(100)),
                child: Column(
                  children: [
                    Container(
                      width: AppSizes.setWidth(80),
                      height: AppSizes.setHeight(80),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Image.asset(
                          AssetsIcon.IC_BAG,
                          width: AppSizes.setWidth(32),
                          height: AppSizes.setHeight(32),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.setHeight(16)),
                    CommonText(
                      text: '暂无相关订单',
                      fontSize: AppSizes.setFontSize(14),
                      textColor: const Color(0xFF6B7280),
                    ),
                  ],
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
            padding: EdgeInsets.all(AppSizes.setWidth(16)),
            itemCount: state.orderList.length,
            itemBuilder: (context, index) {
              final order = state.orderList[index];
              return Padding(
                padding: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
                child: _buildOrderCard(order, context),
              );
            },
          ),
        );
      },
    );
  }

  _tabBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: AppSizes.setHeight(8),
        bottom: AppSizes.setHeight(12),
        left: AppSizes.setWidth(16),
        right: AppSizes.setWidth(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(AppSizes.setWidth(4)),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppColor.txtPurple,
          unselectedLabelColor: const Color(0xFF6B7280),
          labelStyle: TextStyle(
            fontSize: AppSizes.setFontSize(14),
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: AppSizes.setFontSize(14),
            fontWeight: FontWeight.w400,
          ),
          tabs: tabList.map((tab) {
            return Tab(
              text: tab,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, BuildContext context) {
    final isCancelled = order.status?.value == OrderStatus.Cancelled.value;
    final isPendingPayment =
        order.status?.value == OrderStatus.PendingPayment.value;
    final isPaid = order.status?.value == OrderStatus.PaymentUploaded.value;

    final isComplete = order.status?.value == OrderStatus.Completed.value;

    return GestureDetector(
      onTap: () {
        BaseRouter.push(
          url: AppPage.payOrderDetailPage.path,
          extra: {'order': order},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCancelled ? const Color(0xFFFAFAFA) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.02),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(AppSizes.setWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部：订单号 + 状态
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CommonText(
                      text: order.orderNo ?? '',
                      fontSize: AppSizes.setFontSize(12),
                      textColor: const Color(0xFF6B7280),
                      fontFamily: 'DIN Alternate',
                    ),
                  ],
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            Divider(
              height: AppSizes.setHeight(12),
              thickness: 1,
              color: const Color(0xFFF3F4F6),
            ),
            // 中部：油品信息 + 价格
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CommonText(
                            /// 油品类型
                            text: FuelTypeHelper.getDisplayName(order.fuelType),
                            fontSize: AppSizes.setFontSize(16),
                            fontWeight: FontWeight.w700,
                            textColor: isCancelled
                                ? const Color(0xFF6B7280)
                                : const Color(0xFF1F2937),
                          ),
                          // SizedBox(width: AppSizes.setWidth(6)),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: AppSizes.setWidth(4),
                          //     vertical: AppSizes.setHeight(1),
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: const Color(0xFFF3F4F6),
                          //     borderRadius: BorderRadius.circular(3),
                          //   ),
                          //   child: CommonText(
                          //     text: '成品油',
                          //     fontSize: AppSizes.setFontSize(10),
                          //     textColor: const Color(0xFF6B7280),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: AppSizes.setHeight(6)),
                      CommonText(
                        text: order.depotName ?? '',
                        fontSize: AppSizes.setFontSize(12),
                        textColor: isCancelled
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CommonText(
                      text: '¥${_formatPrice(order.totalAmount ?? 0)}',
                      fontSize: AppSizes.setFontSize(20),
                      fontWeight: FontWeight.w700,
                      textColor: isCancelled
                          ? const Color(0xFF6B7280)
                          : const Color(0xFF1F2937),
                      fontFamily: 'DIN Alternate',
                    ),
                    SizedBox(height: AppSizes.setHeight(2)),
                    CommonText(
                      text: '订单金额',
                      fontSize: AppSizes.setFontSize(10),
                      textColor: const Color(0xFF6B7280),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSizes.setHeight(12)),
            // 数据行：购买量、支付方式
            Container(
              padding: EdgeInsets.all(AppSizes.setWidth(10)),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    text: '购买量: ',
                    fontSize: AppSizes.setFontSize(12),
                    textColor: isCancelled
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                  CommonText(
                    text: '${order.purchaseTon?.toStringAsFixed(0) ?? '0'} 吨',
                    fontSize: AppSizes.setFontSize(12),
                    fontWeight: FontWeight.w600,
                    textColor: isCancelled
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF1F2937),
                  ),
                  SizedBox(width: AppSizes.setWidth(16)),
                  CommonText(
                    text: '支付方式: ',
                    fontSize: AppSizes.setFontSize(12),
                    textColor: isCancelled
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                  CommonText(
                    text: '对公转账',
                    fontSize: AppSizes.setFontSize(12),
                    fontWeight: FontWeight.w600,
                    textColor: isCancelled
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF1F2937),
                  ),
                ],
              ),
            ),
            // 底部按钮
            if ((!isCancelled && !isComplete) || isPaid)
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isPendingPayment) ...[
                      _buildActionButton(
                        text: '取消订单',
                        isOutline: true,
                        onTap: () {
                          context
                              .read<PayOrderListCtrl>()
                              .reasonOfCancellation(context, order);
                        },
                      ),
                      SizedBox(width: AppSizes.setWidth(12)),
                      _buildActionButton(
                        text: '去支付',
                        isOutline: false,
                        isPrimary: true,
                        onTap: () {
                          BaseRouter.push(
                            url: AppPage.payOrderDetailPage.path,
                            extra: {'order': order},
                          );
                        },
                      ),
                    ] else if (!isCancelled) ...[
                      _buildActionButton(
                        text: '查看详情',
                        isOutline: false,
                        isPrimary: true,
                        onTap: () {
                          BaseRouter.push(
                            url: AppPage.payOrderDetailPage.path,
                            extra: {'order': order},
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            if (isCancelled || isComplete)
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      text: '查看详情',
                      isOutline: true,
                      textColor: const Color(0xFF6B7280),
                      borderColor: const Color(0xFFE5E7EB),
                      onTap: () {
                        BaseRouter.push(
                          url: AppPage.payOrderDetailPage.path,
                          extra: {'order': order},
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus? status) {
    String text = status?.displayName ?? '';
    Color bgColor;
    Color textColor;
    Widget? icon;

    switch (status) {
      case OrderStatus.PendingPayment:
        bgColor = const Color(0xFFFFF7ED);
        textColor = const Color(0xFFF59E0B);
        icon = Icon(
          Icons.access_time,
          size: AppSizes.setWidth(10),
          color: textColor,
        );
        break;
      case OrderStatus.PaymentUploaded:
        bgColor = const Color(0xFFEFF6FF);
        textColor = const Color(0xFF3B82F6);
        break;
      case OrderStatus.Cancelled:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF9CA3AF);
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF9CA3AF);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(8),
        vertical: AppSizes.setHeight(2),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon,
            SizedBox(width: AppSizes.setWidth(4)),
          ],
          CommonText(
            text: text,
            fontSize: AppSizes.setFontSize(11),
            fontWeight: FontWeight.w600,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onTap,
    bool isOutline = false,
    bool isPrimary = false,
    Color? textColor,
    Color? borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.setWidth(16),
          vertical: AppSizes.setHeight(8),
        ),
        decoration: BoxDecoration(
          color: isPrimary
              ? const Color(0xFFF59E0B)
              : (isOutline ? Colors.white : AppColor.txtPurple),
          border: isOutline
              ? Border.all(
                  color: borderColor ?? const Color(0xFFD1D5DB),
                  width: 1,
                )
              : null,
          borderRadius: BorderRadius.circular(18),
        ),
        child: CommonText(
          text: text,
          fontSize: AppSizes.setFontSize(13),
          fontWeight: FontWeight.w500,
          textColor: textColor ??
              (isOutline
                  ? (isPrimary ? AppColor.txtPurple : const Color(0xFF1F2937))
                  : Colors.white),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }
}
