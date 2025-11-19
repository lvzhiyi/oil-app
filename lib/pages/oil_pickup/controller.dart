import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup/service/oil_pickup_service.dart';
import 'package:oil_business_app/pages/oil_pickup/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';

class OilPickupCtrl extends Cubit<OilPickupState> {
  OilPickupCtrl() : super(OilPickupState()) {
    loadInventories();
  }

  static const int _pageSize = 10;

  Future<void> loadInventories() async {
    emit(state.copyWith(isLoading: true, errorMessage: null, currentPage: 1, inventories: []));

    try {
      final response = await oilPickupService.getInventories(
        page: 1,
        pageSize: _pageSize,
      );

      final list = response.list ?? [];
      final hasMore = list.length >= _pageSize;

      emit(state.copyWith(
        isLoading: false,
        inventories: list,
        hasMore: hasMore,
      ));
    } catch (e) {
      l.e('OilPickup', '加载库存列表失败: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: '加载失败，请重试',
      ));
    }
  }

  Future<void> loadMoreInventories() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentPage + 1;
      final response = await oilPickupService.getInventories(
        page: nextPage,
        pageSize: _pageSize,
      );

      final list = response.list ?? [];
      final hasMore = list.length >= _pageSize;

      emit(state.copyWith(
        isLoadingMore: false,
        inventories: [...state.inventories, ...list],
        currentPage: nextPage,
        hasMore: hasMore,
      ));
    } catch (e) {
      l.e('OilPickup', '加载更多库存失败: $e');
      emit(state.copyWith(
        isLoadingMore: false,
        // 不显示错误，只是停止加载
      ));
    }
  }

  Future<void> navigateToDetail(BuildContext context, InventoryModel inventory) async {
    final result = await BaseRouter.push(
      context: context,
      url: AppPage.oilPickupDetailPage.path,
      extra: inventory,
    );
    if (result == true) {
      loadInventories();
    }
  }
}