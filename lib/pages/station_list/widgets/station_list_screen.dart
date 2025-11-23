import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/station_list/controller.dart';
import 'package:oil_business_app/pages/station_list/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/global_update_ui.dart';

import 'station_item.dart';

class StationListScreen extends StatelessWidget {
  final StationListState state;
  final StationListCtrl controller;
  final bool allowEdit;

  const StationListScreen({
    Key? key,
    required this.state,
    required this.controller,
    this.allowEdit = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgScaffold,
      appBar: AppBar(
        backgroundColor: CustomAppColor.of(context).bgScaffold,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomAppColor.of(context).txtBlack,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: CommonText(
          text: '选择加油站',
          fontSize: AppSizes.setFontSize(18),
          fontWeight: FontWeight.w600,
          textColor: CustomAppColor.of(context).txtBlack,
        ),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (state.isLoading && state.stations.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.hasError && state.stations.isEmpty) {
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
              onTap: () => controller.onRefresh(),
            ),
          ],
        ),
      );
    }

    if (state.stations.isEmpty && !state.isLoading) {
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

    return GlobalUpdateUi(
      builder: (context, appCtrl) {
        final selectedStation = appCtrl.state.selectedStation;
        
        return Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50 &&
                      !state.isLoadingMore &&
                      state.hasMore) {
                    controller.onLoadMore();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppSizes.setWidth(20)),
                    itemCount: state.stations.length + 1, // +1 for loading/footer
                    itemBuilder: (context, index) {
                      if (index == state.stations.length) {
                        return _buildFooter(context);
                      }

                      final station = state.stations[index];
                      final isSelected = selectedStation?.id == station.id;
                      
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
                        child: StationItem(
                          station: station,
                          isSelected: isSelected,
                          onTap: () => controller.selectStation(station, context),
                          onEdit: allowEdit ? () => controller.navigateToEdit(station, context) : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (allowEdit) _buildAddButton(context),
          ],
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (state.isLoadingMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(16)),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!state.hasMore && state.stations.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(16)),
        child: Center(
          child: CommonText(
            text: '没有更多数据了',
            fontSize: AppSizes.setFontSize(12),
            textColor: CustomAppColor.of(context).txtGrey,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(20)),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).bgScaffold,
        border: Border(
          top: BorderSide(
            color: CustomAppColor.of(context).containerBorder,
            width: 1,
          ),
        ),
      ),
      child: CommonButton(
        btnText: '新增加油站',
        height: AppSizes.setHeight(52),
        fontSize: AppSizes.setFontSize(15),
        onTap: () => controller.navigateToAdd(context),
      ),
    );
  }
}

