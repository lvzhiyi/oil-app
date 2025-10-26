import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/size.dart';
import 'package:lottery_app/utils/pt.dart';

class SportsDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool readOnly;
  final Widget Function(DateTime? selectedDate) childBuilder;
  final void Function(DateTime? selectedDate)? onChanged;
  const SportsDatePicker({
    super.key,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.onChanged,
    this.readOnly = false,
    required this.childBuilder,
  });

  @override
  State<SportsDatePicker> createState() => DatePickerState();
}

class DatePickerState extends State<SportsDatePicker> {
  DateTime? _currentDate;
  void _changeDate(DateTime? date) {
    setState(() {
      _currentDate = date;
      widget.onChanged?.call(date);
    });
  }

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    // widget.
    return Column(
      children: [
        GestureDetector(
          child: widget.childBuilder(_currentDate),
          onTap: () {
            if (widget.readOnly) {
              return;
            }
            Picker(
              height: pt(180),
              adapter: DateTimePickerAdapter(
                type: PickerDateTimeType.kMDY,
                value: _currentDate ?? DateTime.now(),
                maxValue: widget.maxDate,
                minValue: widget.minDate,
                customColumnType: [2, 1, 0],
                isNumberMonth: true,
                yearEnd: widget.maxDate?.year ?? DateTime.now().year,
              ),
              selectedTextStyle: TextStyle(color: AppColors.darkBlue),
              title: null,
              onConfirm: (Picker picker, List value) {
                String pickerText = picker.adapter.text;
                _changeDate(
                  DateTime.parse(pickerText),
                );
              },
              headerDecoration: BoxDecoration(
                color: Colors.white,
                boxShadow: AppSize.boxShadow,
              ),
              cancelTextStyle: const TextStyle(color: AppColors.nearlyBlack),
              confirmTextStyle: TextStyle(color: AppColors.darkBlue),
              itemExtent: pt(36),
              selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                background: CupertinoColors.quaternarySystemFill,
                capStartEdge: false,
                capEndEdge: false,
              ),
              backgroundColor: Colors.white,
            ).showModal(
              context,
              builder: (context, pickerWidget) {
                return Container(
                  color: Colors.white,
                  child: SafeArea(
                    maintainBottomViewPadding: true,
                    child: pickerWidget,
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }
}
