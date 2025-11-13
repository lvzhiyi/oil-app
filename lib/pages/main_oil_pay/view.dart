import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/pages/main_oil_pay/controller.dart';
import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/size.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/common/empty_card.dart';
import 'package:oil_business_app/widgets/common/pull_refresh_easy.dart';

import 'state.dart';

class MainOilPayView extends StatefulWidget {
  final MainOilPayState state;
  final Map<String, dynamic>? extra;

  const MainOilPayView({super.key, required this.state, this.extra});

  @override
  State<MainOilPayView> createState() => _MainOilPayViewState();
}

class _MainOilPayViewState extends State<MainOilPayView> {
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
    final state = widget.state;

    // 加载中且无数据
    if (state.isLoading && (state.depotList == null || state.depotList!.isEmpty)) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 错误状态
    if (state.errorMessage != null && (state.depotList == null || state.depotList!.isEmpty)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsImg.PAGE_ERROR,
              width: pt(120),
              height: pt(120),
            ),
            Gap(pt(16)),
            Text(
              state.errorMessage ?? '加载失败',
              style: SportsTextStyle.baseNormal.copyWith(
                color: CustomAppColor.of(context).txtGrey,
              ),
            ),
            Gap(pt(16)),
            ElevatedButton(
              onPressed: () {
                context.read<OilPayCtrl>().refresh();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    // 空状态
    if (state.depotList == null || state.depotList!.isEmpty) {
      return Center(
        child: EmptyCard(
          desc: '暂无油库数据',
          icon: Image.asset(
            AssetsImg.PAGE_EMPTY,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    // 列表内容
    return PullOrRefreshEasy(
      refreshController: _refreshController,
      onRefresh: () async {
        await context.read<OilPayCtrl>().refresh();
        _refreshController.finishRefresh();
      },
      onLoading: () async {
        await context.read<OilPayCtrl>().loadMore();
        final currentState = context.read<OilPayCtrl>().state;
        if (currentState.depotList != null &&
            currentState.depotList!.length >= currentState.total) {
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
        itemCount: state.depotList?.length ?? 0,
        itemBuilder: (context, index) {
          final depot = state.depotList![index];
          return _DepotCard(depot: depot);
        },
      ),
    );
  }
}

/// 油库卡片组件
class _DepotCard extends StatelessWidget {
  final Depot depot;

  const _DepotCard({required this.depot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: pt(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSize.radius,
        boxShadow: AppSize.boxShadow,
      ),
      child: InkWell(
        onTap: () {
          // TODO: 跳转到油库详情或下单页面
        },
        borderRadius: AppSize.radius,
        child: Padding(
          padding: EdgeInsets.all(pt(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 油库名称
              Row(
                children: [
                  Expanded(
                    child: Text(
                      depot.depotName ?? '未知油库',
                      style: SportsTextStyle.baseBold.copyWith(
                        fontSize: pt(18),
                        color: CustomAppColor.of(context).txtBlack,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(pt(12)),
              // 地址信息
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    size: pt(16),
                    color: CustomAppColor.of(context).txtGrey,
                  ),
                  Gap(pt(6)),
                  Expanded(
                    child: Text(
                      _buildAddress(depot),
                      style: SportsTextStyle.baseNormal.copyWith(
                        fontSize: pt(14),
                        color: CustomAppColor.of(context).txtGrey,
                      ),
                    ),
                  ),
                ],
              ),
              if (depot.fuels != null && depot.fuels!.isNotEmpty) ...[
                Gap(pt(16)),
                const Divider(height: 1),
                Gap(pt(12)),
                // 油品列表
                Text(
                  '油品信息',
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(12),
                    color: CustomAppColor.of(context).txtGrey,
                  ),
                ),
                Gap(pt(8)),
                Wrap(
                  spacing: pt(8),
                  runSpacing: pt(8),
                  children: depot.fuels!.map((fuel) {
                    return _FuelTag(
                      fuelType: fuel.fuelType ?? '',
                      price: fuel.priceCny ?? 0,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _buildAddress(Depot depot) {
    final parts = <String>[];
    if (depot.provinceName != null && depot.provinceName!.isNotEmpty) {
      parts.add(depot.provinceName!);
    }
    if (depot.cityName != null && depot.cityName!.isNotEmpty) {
      parts.add(depot.cityName!);
    }
    if (depot.areaName != null && depot.areaName!.isNotEmpty) {
      parts.add(depot.areaName!);
    }
    if (depot.addressDetail != null && depot.addressDetail!.isNotEmpty) {
      parts.add(depot.addressDetail!);
    }
    return parts.isEmpty ? '地址信息暂无' : parts.join(' ');
  }
}

/// 油品标签组件
class _FuelTag extends StatelessWidget {
  final String fuelType;
  final double price;

  const _FuelTag({
    required this.fuelType,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: pt(12),
        vertical: pt(6),
      ),
      decoration: BoxDecoration(
        color: AppColor.cardBlue.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(pt(6)),
        border: Border.all(
          color: AppColor.btnPurple.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            fuelType,
            style: SportsTextStyle.baseBold.copyWith(
              fontSize: pt(12),
              color: CustomAppColor.of(context).txtBlack,
            ),
          ),
          Gap(pt(4)),
          Text(
            '¥${price.toStringAsFixed(2)}',
            style: SportsTextStyle.baseBold.copyWith(
              fontSize: pt(14),
              color: AppColor.txtRed,
            ),
          ),
        ],
      ),
    );
  }
}
