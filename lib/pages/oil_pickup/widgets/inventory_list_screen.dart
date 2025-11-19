import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/oil_pickup/controller.dart';
import 'package:oil_business_app/pages/oil_pickup/state.dart';
import 'package:oil_business_app/pages/oil_pickup/widgets/inventory_item.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.controller.loadMoreInventories();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: CustomAppColor.of(context).btnPurple,
        ),
      );
    }

    if (widget.state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonText(
              text: widget.state.errorMessage!,
              textColor: CustomAppColor.of(context).txtGrey,
            ),
            TextButton(
              onPressed: widget.controller.loadInventories,
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    if (widget.state.inventories.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(12),
        vertical: AppSizes.setWidth(12),
      ),
      itemCount: widget.state.inventories.length + 1,
      separatorBuilder: (context, index) => SizedBox(height: AppSizes.setHeight(12)),
      itemBuilder: (context, index) {
        if (index == widget.state.inventories.length) {
          return _buildLoadingMoreIndicator(context);
        }
        final inventory = widget.state.inventories[index];
        return InventoryItem(
          inventory: inventory,
          onTap: () => widget.controller.navigateToDetail(context, inventory),
        );
      },
    );
  }

  Widget _buildLoadingMoreIndicator(BuildContext context) {
    if (widget.state.isLoadingMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(16)),
        child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: CustomAppColor.of(context).btnPurple,
            )
        ),
      );
    }
    if (!widget.state.hasMore && widget.state.inventories.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(16)),
        child: CommonText(
          text: '没有更多库存了',
          textColor: CustomAppColor.of(context).txtGrey,
          fontSize: AppSizes.setFontSize(12),
        ),
      );
    }
    return SizedBox.shrink();
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
