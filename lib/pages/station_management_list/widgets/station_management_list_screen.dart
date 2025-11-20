import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/pages/station_management_list/controller.dart';
import 'package:oil_business_app/pages/station_management_list/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

import 'station_management_item.dart';

class StationManagementListScreen extends StatelessWidget {
  final StationManagementListState state;
  final StationManagementListCtrl controller;

  const StationManagementListScreen({
    Key? key,
    required this.state,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgTopBar,
      body: SafeArea(
        bottom: true,
        top: false,
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: _buildBody(context),
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
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: _buildNavBar(context),
          ),
          _buildFilterBar(context),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Container(
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
            onTap: () => Navigator.of(context).pop(),
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
              text: '加油站管理',
              fontSize: AppSizes.setFontSize(18),
              fontWeight: FontWeight.bold,
              textColor: CustomAppColor.of(context).txtBlack,
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () => controller.navigateToAdd(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.setWidth(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: AppSizes.setFontSize(14),
                    color: CustomAppColor.of(context).btnPurple,
                  ),
                  SizedBox(width: AppSizes.setWidth(4)),
                  CommonText(
                    text: '新增',
                    fontSize: AppSizes.setFontSize(14),
                    fontWeight: FontWeight.bold,
                    textColor: CustomAppColor.of(context).btnPurple,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final isAllSelected = state.selectedStatus == null;
    final isActiveSelected = state.selectedStatus == StationStatus.active;
    final isPendingSelected = state.selectedStatus == StationStatus.pending_review;
    final isRejectedSelected = state.selectedStatus == StationStatus.rejected;
    final isDisabledSelected = state.selectedStatus == StationStatus.disabled;

    return Container(
      color: CustomAppColor.of(context).bgContainer,
      child: Row(
        children: [
          Expanded(
            child: _buildFilterTab(
              context: context,
              label: '全部',
              isSelected: isAllSelected,
              onTap: () => controller.filterByStatus(null),
            ),
          ),
          Expanded(
            child: _buildFilterTab(
              context: context,
              label: '正常',
              isSelected: isActiveSelected,
              onTap: () => controller.filterByStatus(StationStatus.active),
            ),
          ),
          Expanded(
            child: _buildFilterTab(
              context: context,
              label: '待审核',
              isSelected: isPendingSelected,
              onTap: () => controller.filterByStatus(StationStatus.pending_review),
            ),
          ),
          Expanded(
            child: _buildFilterTab(
              context: context,
              label: '已驳回',
              isSelected: isRejectedSelected,
              onTap: () => controller.filterByStatus(StationStatus.rejected),
            ),
          ),
          Expanded(
            child: _buildFilterTab(
              context: context,
              label: '禁用',
              isSelected: isDisabledSelected,
              onTap: () => controller.filterByStatus(StationStatus.disabled),
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
          vertical: AppSizes.setHeight(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText(
              text: label,
              fontSize: AppSizes.setFontSize(18),
              fontWeight: FontWeight.w500,
              textColor: isSelected ? colors.btnPurple : colors.txtGrey,
            ),
            SizedBox(height: AppSizes.setHeight(8)),
            if (isSelected)
              Container(
                width: AppSizes.setWidth(26),
                height: AppSizes.setWidth(3),
                decoration: BoxDecoration(
                  color: colors.btnPurple,
                  borderRadius: BorderRadius.circular(AppSizes.setWidth(1.5)),
                ),
              )
            else
              SizedBox(height: AppSizes.setWidth(3)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.hasError) {
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
              onTap: () => controller.initState(),
            ),
          ],
        ),
      );
    }

    if (state.stations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonText(
              text: '暂无加油站数据',
              fontSize: AppSizes.setFontSize(16),
              textColor: CustomAppColor.of(context).txtGrey,
            ),
            SizedBox(height: AppSizes.setHeight(20)),
            CommonButton(
              btnText: '新增加油站',
              width: AppSizes.setWidth(150),
              height: AppSizes.setHeight(44),
              fontSize: AppSizes.setFontSize(14),
              onTap: () => controller.navigateToAdd(context),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      itemCount: state.stations.length,
      itemBuilder: (context, index) {
        final station = state.stations[index];
        return Padding(
          padding: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
          child: StationManagementItem(
            station: station,
            onEdit: () => controller.navigateToEdit(station, context),
          ),
        );
      },
    );
  }
}
