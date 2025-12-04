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
      backgroundColor: CustomAppColor.of(context).bgScaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomAppColor.of(context).txtBlack,
          ),
          onPressed: () => BaseRouter.pop(),
        ),
      ),
      body: SingleChildScrollView(
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
                    style: SportsTextStyle.baseNormal.copyWith(
                      fontSize: pt(14),
                      color: CustomAppColor.of(context).txtGrey,
                    ),
                  ),
                ),
                Gap(pt(24)),
                // 油品列表
                if (depot.fuels != null && depot.fuels!.isNotEmpty) ...[
                  ...depot.fuels!.map((fuel) {
                    final isSelected =
                        state.selectedFuel?.fuelType == fuel.fuelType;
                    return _FuelItem(
                      fuel: fuel,
                      isSelected: isSelected,
                      onTap: () {
                        context.read<OilPurchaseDetailCtrl>().selectFuel(fuel);
                      },
                    );
                  }),
                  Gap(pt(24)),
                ],
                // 购买量输入框
                Text(
                  '购买量',
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(14),
                    color: CustomAppColor.of(context).txtBlack,
                  ),
                ),
                Gap(pt(8)),
                CommonTextFormField(
                  name: 'purchaseTon',
                  hintText: '请输入购买量',
                  keyboardType: TextInputType.number,
                  inputFormatter: FilteringTextInputFormatter.digitsOnly,
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
                Text(
                  '备注信息',
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(14),
                    color: CustomAppColor.of(context).txtBlack,
                  ),
                ),
                Gap(pt(8)),
                const CommonTextFormField(
                  name: 'remark',
                  hintText: '请输入备注信息',
                  maxLines: 4,
                ),

                Gap(pt(32)),
                // 立刻购买按钮
                SizedBox(
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
                      disabledBackgroundColor:
                          CustomAppColor.of(context).txtGrey,
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
              ],
            ),
          ),
        ),
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
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: pt(12)),
        padding: EdgeInsets.all(pt(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColor.btnPurple
                : CustomAppColor.of(context).textFieldBorder,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(pt(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 左侧：油品类型
            Text(
              fuel.fuelType ?? '',
              style: SportsTextStyle.baseBold.copyWith(
                fontSize: pt(16),
                color: CustomAppColor.of(context).txtBlack,
              ),
            ),
            // 右侧：价格
            Text(
              '${fuel.priceCny?.toStringAsFixed(0) ?? '0'}元/吨',
              style: SportsTextStyle.baseNormal.copyWith(
                fontSize: pt(14),
                color: CustomAppColor.of(context).txtBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
