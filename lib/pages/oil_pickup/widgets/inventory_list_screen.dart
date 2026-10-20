import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/oil_pickup/controller.dart';
import 'package:oil_business_app/pages/oil_pickup/state.dart';
import 'package:oil_business_app/pages/oil_pickup/widgets/inventory_item.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:oil_business_app/widgets/common/pull_refresh_easy.dart';

class InventoryListScreen extends StatefulWidget {
  final OilPickupState state;
  final OilPickupCtrl controller;

  const InventoryListScreen({
    Key? key,
    required this.state,
    required this.controller,
  }) : super(key: key);

  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  late EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.isLoading && widget.state.inventories.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: CustomAppColor.of(context).btnPurple,
        ),
      );
    }

    if (widget.state.errorMessage != null && widget.state.inventories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonText(
              text: widget.state.errorMessage!,
              textColor: CustomAppColor.of(context).txtGrey,
            ),
            TextButton(
              onPressed: () =>
                  widget.controller.loadInventories(isRefresh: true),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (widget.state.inventories.isEmpty && !widget.state.isLoading) {
      return PullOrRefreshEasy(
        refreshController: _refreshController,
        onRefresh: () async {
          await widget.controller.loadInventories(isRefresh: true);
          _refreshController.finishRefresh();
        },
        child: _buildEmptyState(context),
      );
    }

    return PullOrRefreshEasy(
      refreshController: _refreshController,
      onRefresh: () async {
        await widget.controller.loadInventories(isRefresh: true);
        _refreshController.finishRefresh();
      },
      onLoading: () async {
        await widget.controller.loadMoreInventories();
        if (!widget.state.hasMore) {
          _refreshController.finishLoad(IndicatorResult.noMore);
        } else {
          _refreshController.finishLoad();
        }
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: pt(12),
          vertical: pt(12),
        ),
        itemCount: widget.state.inventories.length,
        itemBuilder: (context, index) {
          final inventory = widget.state.inventories[index];
          return InventoryItem(
            inventory: inventory,
            onTap: () => widget.controller.navigateToDetail(context, inventory),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetsImg.PAGE_EMPTY,
            width: AppSizes.setWidth(180),
            height: AppSizes.setHeight(180),
            fit: BoxFit.contain,
          ),
          SizedBox(height: AppSizes.setHeight(20)),
          CommonText(
            text: '您还没有库存油哦~',
            fontSize: AppSizes.setFontSize(14),
            fontWeight: FontWeight.w400,
            textColor: CustomAppColor.of(context).txtGrey,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
