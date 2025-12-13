import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';
import 'package:oil_business_app/pages/main_oil_pay/oil_purchase_detail/controller.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/size.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';

import 'state.dart';

class OilPurchaseDetailView extends StatelessWidget {
  final OilPurchaseDetailState state;

  const OilPurchaseDetailView({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final depot = state.depot;
    if (depot == null) {
      return const Center(child: Text('油库信息不存在'));
    }

    final ctrl = context.read<OilPurchaseDetailCtrl>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: CommonText(
          text: '买油',
          fontSize: AppSizes.setFontSize(18),
          fontWeight: FontWeight.w600,
          textColor: CustomAppColor.of(context).txtBlack,
        ),
        centerTitle: true,
        backgroundColor: CustomAppColor(context).white,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // 黑色图标
          statusBarBrightness: Brightness.light, // iOS 白色背景
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomAppColor.of(context).txtBlack,
          ),
          onPressed: () => BaseRouter.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(pt(16)),
              child: FormBuilder(
                key: ctrl.formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppSize.radius,
                    boxShadow: AppSize.boxShadow,
                  ),
                  padding: EdgeInsets.all(pt(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 顶部：油库名称（居中）
                      Center(
                        child: Text(
                          depot.depotName ?? '未知油库',
                          style: SportsTextStyle.baseBold.copyWith(
                            fontSize: pt(20),
                            color: CustomAppColor.of(context).txtBlack,
                          ),
                        ),
                      ),
                      Gap(pt(8)),
                      // 地址（居中）
                      Center(
                        child: Text(
                          _buildAddress(depot),
                          textAlign: TextAlign.center,
                          style: SportsTextStyle.baseNormal.copyWith(
                            fontSize: pt(14),
                            color: CustomAppColor.of(context).txtGrey,
                          ),
                        ),
                      ),
                      Gap(pt(24)),
                      // 油品列表 - 横向排列
                      if (depot.fuels != null && depot.fuels!.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: depot.fuels!.map((fuel) {
                            final isSelected =
                                state.selectedFuel?.fuelType == fuel.fuelType;
                            return Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.05,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: pt(4),
                                  ),
                                  child: _FuelItem(
                                    fuel: fuel,
                                    isSelected: isSelected,
                                    onTap: () {
                                      context
                                          .read<OilPurchaseDetailCtrl>()
                                          .selectFuel(fuel);
                                    },
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Gap(pt(24)),
                      ],
                      // 购买量输入框
                      Text(
                        '购买量',
                        style: SportsTextStyle.baseBold.copyWith(
                          fontSize: pt(14),
                          color: CustomAppColor.of(context).txtBlack,
                        ),
                      ),
                      Gap(pt(12)),
                      CommonTextFormField(
                        name: 'purchaseTon',
                        hintText: '请输入购买量',
                        keyboardType: TextInputType.number,
                        inputFormatter: FilteringTextInputFormatter.digitsOnly,
                        suffixIcon: Container(
                          padding: EdgeInsets.only(right: pt(16)),
                          alignment: Alignment.centerRight,
                          width: pt(50),
                          child: Text(
                            '吨',
                            style: SportsTextStyle.baseNormal.copyWith(
                              fontSize: pt(14),
                              color: CustomAppColor.of(context).txtBlack,
                            ),
                          ),
                        ),
                        validators: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入购买量';
                          }
                          final intValue = int.tryParse(value);
                          if (intValue == null) {
                            return '购买量必须为整数';
                          }
                          if (intValue <= 0) {
                            return '购买量必须大于0';
                          }
                          return null;
                        },
                      ),

                      Gap(pt(16)),
                      // Text(
                      //   '备注信息',
                      //   style: SportsTextStyle.baseNormal.copyWith(
                      //     fontSize: pt(14),
                      //     color: CustomAppColor.of(context).txtBlack,
                      //   ),
                      // ),
                      // Gap(pt(8)),
                      // CommonTextFormField(
                      //   name: 'remark',
                      //   hintText: '请输入备注信息',
                      //   maxLines: 4,
                      //   validators: (_) => null,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: pt(16),
              vertical: pt(12),
            ),
            decoration: BoxDecoration(
              color: CustomAppColor(context).white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.only(bottom: pt(4)),
              child: SizedBox(
                width: double.infinity,
                height: pt(48),
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context
                              .read<OilPurchaseDetailCtrl>()
                              .submitPurchase(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.btnPurple,
                    disabledBackgroundColor: CustomAppColor.of(context).txtGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(pt(12)),
                    ),
                    elevation: 0,
                  ),
                  child: state.isLoading
                      ? SizedBox(
                          width: pt(20),
                          height: pt(20),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          '立刻购买',
                          style: SportsTextStyle.baseBold.copyWith(
                            fontSize: pt(16),
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建地址字符串
  String _buildAddress(depot) {
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
    return parts.isEmpty ? '地址信息暂无' : parts.join('');
  }
}

/// 油品项组件
class _FuelItem extends StatelessWidget {
  final Fuel fuel;
  final bool isSelected;
  final VoidCallback onTap;

  const _FuelItem({
    required this.fuel,
    required this.isSelected,
    required this.onTap,
  });



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(pt(8)),
          color: isSelected ? const Color(0xFFFFFAF5) : const Color(0xFFF5F7FA),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF8D1A) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // 主要内容 - 居中对齐
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 油品类型
                  Text(
                    '${fuel.fuelType ?? ''}#',
                    textAlign: TextAlign.center,
                    style: SportsTextStyle.baseBold.copyWith(
                      fontSize: pt(16),
                      color: isSelected
                          ? const Color(0xFFFF8D1A)
                          : CustomAppColor.of(context).txtBlack,
                    ),
                  ),
                  Gap(pt(4)),
                  // 价格行
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        fuel.priceCny?.toStringAsFixed(0) ?? '0',
                        style: SportsTextStyle.baseBold.copyWith(
                          fontSize: pt(14),
                          color: isSelected
                              ? const Color(0xFFFF8D1A)
                              : CustomAppColor.of(context).txtBlack,
                          height: 1.1,
                        ),
                      ),
                      Gap(pt(2)),
                      Text(
                        '元/吨',
                        style: SportsTextStyle.baseNormal.copyWith(
                          fontSize: pt(12),
                          color: isSelected
                              ? const Color(0xFFFF8D1A)
                              : CustomAppColor.of(context).txtBlack,
                        ),
                      ),
                    ],
                  ),
                  Gap(pt(4)),
                  // 密度
                  Text(
                    '密度: ${fuel.density?.toStringAsFixed(2) ?? '0.00'}',
                    textAlign: TextAlign.center,
                    style: SportsTextStyle.baseNormal.copyWith(
                      fontSize: pt(12),
                      color: isSelected ? const Color(0xFFFF8D1A) : CustomAppColor.of(context).txtGrey,
                    ),
                  ),
                ],
              ),
            ),
            // 选中时的勾选图标 - 右下角
            // if (isSelected)
            //   Positioned(
            //     right: 0,
            //     bottom: 0,
            //     child: Container(
            //       width: pt(24),
            //       height: pt(20),
            //       decoration: BoxDecoration(
            //         color: const Color(0xFFFF8D1A),
            //         borderRadius: BorderRadius.only(
            //           topLeft: Radius.circular(pt(60)),
            //           bottomRight: Radius.circular(pt(6)),
            //         ),
            //       ),
            //       alignment: Alignment.center,
            //       child: Icon(
            //         Icons.check,
            //         color: Colors.white,
            //         size: pt(14),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
