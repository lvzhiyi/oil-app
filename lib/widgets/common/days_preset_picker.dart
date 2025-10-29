import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/utils/date_util.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';

import 'single_list_picker/common_type.dart';
import 'single_list_picker/single_list_picker.dart';

class DaysPresetPicker extends StatefulWidget {
  /// 初始选中的值
  final String? initialValue;

  /// 选中值改变时的回调
  final ValueChanged<String>? onChanged;

  /// 选择器范围
  final List<SingleListPickerOption>? options;

  /// 已选择时间范围的文本样式
  final TextStyle? textStyle;

  /// 是否将天数转换成月份计算
  final bool isTransformDaysToMonth;

  /// 天数转换成月份的阈值，默认为30天，即30天以上的天数将转换成月份
  final int daysToMonthsThreshold;

  /// 已选择时间范围字符串的格式
  final String format;
  const DaysPresetPicker({
    super.key,
    this.initialValue,
    this.onChanged,
    this.options,
    this.textStyle,
    this.isTransformDaysToMonth = false,
    this.format = 'dd/MM/yyyy',
    this.daysToMonthsThreshold = 30,
  });

  @override
  State<DaysPresetPicker> createState() => _DaysPresetPickerState();
}

class _DaysPresetPickerState extends State<DaysPresetPicker> {
  String _selectedValue = '7';
  void _changeValue(String value) {
    setState(() {
      _selectedValue = value;
      widget.onChanged?.call(value);
    });
  }

  String _getSelectedValueString(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    if (int.parse(value) <= 30) {
      return 'Last $value days';
    }
    return 'Last ${(int.parse(value) / 30).floor()} months';
  }

  /// 根据天数，转换成N天前为开始时间，当前时间为结束时间的日期范围文本字符串
  ///
  /// - `value` 天数
  /// - `normalToMonth` 是否将天数转换成月份计算
  ///
  /// 返回日期范围文本字符串
  String _getDateRangeText(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    int dateValue = int.parse(value);
    DateTime now = DateTime.now();
    DateTime start;
    const monthDays = 30;
    if (dateValue > widget.daysToMonthsThreshold &&
        widget.isTransformDaysToMonth) {
      int months = (dateValue / monthDays).floor();
      start = DateTime(now.year, now.month - months, now.day);
    } else {
      start = now.subtract(Duration(days: dateValue));
    }

    return '${formatDate(start, format: widget.format)} - ${formatDate(now, format: widget.format)}';
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedValue = widget.initialValue ?? '7';
    });
  }

  List<SingleListPickerOption> _getOptions() {
    final options = widget.options ??
        [
          // SingleListPickerOption(
          //   value: '1',
          //   label: 'Today',
          // ),
          SingleListPickerOption(
            value: '7',
            label: 'Last 7 days',
          ),
          SingleListPickerOption(
            value: '30',
            label: 'Last 30 days',
          ),
          SingleListPickerOption(
            value: '90',
            label: 'Last 3 months',
          ),
          SingleListPickerOption(
            value: '180',
            label: 'Last 6 months',
          ),
        ];

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getDateRangeText(_selectedValue),
          style: widget.textStyle,
        ),
        SingleListPicker(
          context: context,
          initialValue: _selectedValue,
          onChanged: (value) {
            _changeValue(value);
          },
          options: _getOptions(),
          childBuild: (value, option) {
            String valueStr = _getSelectedValueString(value);

            return Container(
              width: pt(112),
              height: pt(22),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.darkBlue,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(pt(11)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    valueStr,
                    style: TextStyle(
                      fontSize: pt(12, isFontSize: true),
                      color: AppColors.darkBlue,
                    ),
                  ),
                  Gap(pt(7)),
                  SvgAsset(
                    assetName: AssetsSvg.ARROW_DOWN,
                    color: AppColors.darkBlue,
                    width: pt(12),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
