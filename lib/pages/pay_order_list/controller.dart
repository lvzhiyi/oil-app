import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/pay_order_list/service/pay_order_list.dart';
import 'package:oil_business_app/pages/pay_order_list/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/bottom_sheet/bottom_sheet.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';

import 'model/orders_data.dart';

class PayOrderListCtrl extends Cubit<PayOrderListState> {
  PayOrderListCtrl()
      : super(
          PayOrderListState(),
        ) {
    initState();
  }

  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  TextEditingController cancelOrderReasonController = TextEditingController();

  int pageNum = 1;
  int total = 0;
  int pageSize = 10;

  initState() async {
    getOrderList();
  }

  /// 加载更多
  void onLoading() async {
    if (state.orderList.length >= total) {
      refreshController.finishLoad(IndicatorResult.noMore);
      return;
    }
    pageNum++;
    await getOrderList(loadMore: true);
    refreshController.finishLoad(IndicatorResult.success);
    emit(state.copyWith(
      orderList: pageNum == 1
          ? state.orderList
          : [...state.orderList, ...state.orderList],
      pageStatus: PageStatus.success,
    ));
  }

  /// 刷新
  void onRefresh() async {
    pageNum = 1;
    await getOrderList(onRefresh: true);
    refreshController.finishRefresh(IndicatorResult.success);
  }

  /// 加载记录列表
  Future<OrderListResponse> getOrderList(
      {bool loadMore = false, bool onRefresh = false, int? status}) async {
    try {
      if (!onRefresh && !loadMore) {
        emit(state.copyWith(pageStatus: PageStatus.loading));
      }

      if (status != null) {
        pageNum = 1;
      }
      OrderListResponse? response;

      response = await payOrderListService.getOrderList(
          page: pageNum, pageSize: pageSize, status: status);

      final List<OrderModel> newRecords = response.list ?? [];
      total = response.total ?? 0;

      /// 加载下一页统一在外部处理新的列表
      if (!loadMore) {
        emit(state.copyWith(
          orderList: newRecords,
          pageStatus: PageStatus.success,
        ));
      }

      if (response.list?.isEmpty ?? true) {
        emit(state.copyWith(pageStatus: PageStatus.empty));
      }

      return response;
    } catch (e) {
      print(e);
      emit(state.copyWith(pageStatus: PageStatus.error));
      pageNum = 1;
      return OrderListResponse(list: [], total: 0);
    }
  }

  /// 取消订单
  Future<void> cancelOrder(String id) async {
    await payOrderListService.cancelOrder(id, cancelOrderReasonController.text);
    cancelOrderReasonController.clear();
  }

  void reasonOfCancellation(BuildContext context, OrderModel order) {
    customBottomSheet(
      isPaddingRequired: false,
      isDone: false,
      context: context,
      maxHeightRatio: 0.5,
      title: '取消订单',
      content: ListView(
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
            padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
            child: CommonTextFormField(
              controller: cancelOrderReasonController,
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
              onTap: () async {
                await cancelOrder(order.id?.toString() ?? '');
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      onRefresh();
    });
  }
}
