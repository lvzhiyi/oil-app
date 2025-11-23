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
  static const int _pageSize = 10;
  int? _currentStatus; // Keep track of current filter status

  PayOrderListCtrl()
      : super(
          PayOrderListState(),
        ) {
    onRefresh();
  }

  TextEditingController cancelOrderReasonController = TextEditingController();

  /// 刷新
  Future<void> onRefresh({int? status}) async {
    if (status != null) {
      _currentStatus = status;
    }
    
    // Prevent redundant refresh if already loading (unless it's a status change which forces refresh)
    if (state.pageStatus == PageStatus.loading && status == null) return;

    emit(state.copyWith(
      pageStatus: PageStatus.loading,
      currentPage: 1,
      hasMore: true,
      errorMessage: null,
      // Clear list if status changed to avoid showing wrong data while loading
      orderList: status != null ? [] : state.orderList, 
    ));

    await _loadData(isRefresh: true);
  }

  /// 加载更多
  Future<void> onLoadMore() async {
    if (state.pageStatus == PageStatus.loading || state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    await _loadData(isRefresh: false);
  }

  Future<void> _loadData({required bool isRefresh}) async {
    try {
      final page = isRefresh ? 1 : state.currentPage + 1;
      
      final response = await payOrderListService.getOrderList(
          page: page, pageSize: _pageSize, status: _currentStatus);

      final newRecords = response.list ?? [];
      final hasMore = newRecords.length >= _pageSize;

      List<OrderModel> finalList;
      if (isRefresh) {
        finalList = newRecords;
      } else {
        finalList = [...state.orderList, ...newRecords];
      }

      emit(state.copyWith(
        orderList: finalList,
        currentPage: page,
        hasMore: hasMore,
        isLoadingMore: false,
        pageStatus: finalList.isEmpty ? PageStatus.empty : PageStatus.success,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
        isLoadingMore: false,
        pageStatus: isRefresh ? PageStatus.error : state.pageStatus, // Only show error page if refresh failed
        errorMessage: e.toString(),
      ));
    }
  }
  
  // Deprecated method kept for compatibility if needed, but redirected to onRefresh
  // Users of this controller should call onRefresh(status: ...) instead
  Future<void> getOrderList({int? status}) async {
    await onRefresh(status: status);
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
