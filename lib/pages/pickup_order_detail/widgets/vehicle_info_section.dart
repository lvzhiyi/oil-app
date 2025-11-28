import 'package:flutter/material.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/pickup_order_detail/widgets/detail_item.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 车辆及司机信息区域组件
///
/// 展示车辆和司机的详细信息，包括车牌号、驾驶员、载重等
class VehicleInfoSection extends StatelessWidget {
  final VehicleModel vehicleModel;

  const VehicleInfoSection({
    Key? key,
    required this.vehicleModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      _buildSectionTitle('车辆及司机信息'),
    ];

    void addItem(String label, String? value, {Widget? valueWidget}) {
      if (value != null && value.trim().isNotEmpty) {
        items.add(
            DetailItem(label: label, value: value, valueWidget: valueWidget));
        items.add(SizedBox(height: AppSizes.setHeight(12)));
      }
    }

    addItem('提油日期', vehicleModel.date);
    addItem(
      '车牌号',
      vehicleModel.plateNumber,
      valueWidget: _buildPlateNumberWidget(vehicleModel.plateNumber),
    );
    addItem('车型', vehicleModel.vehicleType);
    addItem('驾驶员', vehicleModel.driverName);
    addItem('联系电话', vehicleModel.driverPhone);
    addItem('身份证号', vehicleModel.driverIdCard);
    addItem('驾驶证编号', vehicleModel.driverLicense);
    addItem('行驶证编号', vehicleModel.vehicleLicense);
    addItem('核定载重', vehicleModel.loadCapacity);
    addItem('单双仓', vehicleModel.tankType);
    addItem('一仓(吨)', vehicleModel.tank1Capacity);
    addItem('二仓(吨)', vehicleModel.tank2Capacity);
    addItem('是否带泵', vehicleModel.hasPump);

    // 移除最后一个 SizedBox
    if (items.isNotEmpty && items.last is SizedBox) {
      items.removeLast();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.setHeight(8)),
      child: CommonText(
        text: title,
        fontSize: AppSizes.setFontSize(13),
        fontWeight: FontWeight.w700,
        textColor: const Color(0xFF6B7280),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget? _buildPlateNumberWidget(String? plateNumber) {
    if (plateNumber == null || plateNumber.isEmpty) return null;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(4),
        vertical: AppSizes.setHeight(2),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(4)),
      ),
      child: CommonText(
        text: plateNumber,
        fontSize: AppSizes.setFontSize(14),
        fontWeight: FontWeight.w500,
        textColor: const Color(0xFF1D4ED8),
      ),
    );
  }
}
