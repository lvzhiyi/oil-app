import 'package:flutter/material.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/pages/station_list/controller.dart';
import 'package:oil_business_app/pages/station_list/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/global_update_ui.dart';
import 'package:oil_business_app/widgets/common/pull_refresh_easy.dart';

import 'station_item.dart';

class StationListScreen extends StatelessWidget {
  final StationListState state;
  final StationListCtrl controller;

  const StationListScreen({
    Key? key,
    required this.state,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
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
              child: PullOrRefreshEasy(
                refreshController: controller.refreshController,
                onRefresh: controller.onRefresh,
                onLoading: controller.onLoadMore,
                child: ListView.builder(
                  padding: EdgeInsets.all(AppSizes.setWidth(16)),
                  itemCount: state.stations.length,
                  itemBuilder: (context, index) {
                    final station = state.stations[index];
                    final isSelected = selectedStation?.id == station.id;

                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
                      child: StationItem(
                        station: station,
                        isSelected: isSelected,
                        onTap: () => controller.selectStation(station, context),
                      ),
                    );
                  },
                ),
              ),
            ),
            _buildBottomButton(context, selectedStation),
          ],
        );
      },
    );
  }

  Widget _buildBottomButton(BuildContext context, Station? selectedStation) {
    final colors = CustomAppColor.of(context);
    final hasSelection = selectedStation != null;

    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.setWidth(16),
        right: AppSizes.setWidth(16),
        top: AppSizes.setHeight(12),
        bottom: AppSizes.setHeight(12) + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: colors.white,
        border: Border(
          top: BorderSide(
            color: colors.containerBorder,
            width: 1,
          ),
        ),
      ),
      child: IgnorePointer(
        ignoring: !hasSelection,
        child: GestureDetector(
          onTap: () {
            final station = selectedStation;
            if (station != null) {
              controller.selectStation(station, context);
            }
          },
          child: Container(
            width: double.infinity,
            height: AppSizes.setHeight(44),
            decoration: BoxDecoration(
              color: hasSelection
                  ? colors.btnPurple
                  : colors.btnPurple.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSizes.setWidth(28)),
            ),
            alignment: Alignment.center,
            child: CommonText(
              text: '确认选择',
              fontSize: AppSizes.setFontSize(16),
              fontWeight: FontWeight.w600,
              textColor: colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
