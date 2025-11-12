import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/station_list/controller.dart';
import 'package:oil_business_app/pages/station_list/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

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
              onTap: () {
                // 预留功能，暂不实现
              },
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(AppSizes.setWidth(20)),
            itemCount: state.stations.length,
            itemBuilder: (context, index) {
              final station = state.stations[index];
              return Padding(
                padding: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
                child: StationItem(
                  station: station,
                  onTap: () => controller.selectStation(station, context),
                  onEdit: () => controller.navigateToEdit(station, context),
                ),
              );
            },
          ),
        ),
        _buildAddButton(context),
      ],
    );
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
        onTap: () {
          // 预留功能，暂不实现
        },
      ),
    );
  }
}

