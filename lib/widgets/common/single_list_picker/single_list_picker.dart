import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/size.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'common_type.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';

class SingleListPicker extends StatefulWidget {
  final String? title;
  final String hintText;
  final String initialValue;
  final bool isRequired;
  final bool disabled;
  final Widget Function(String value)? validator;
  final Widget Function(String? value, SingleListPickerOption? option)?
      childBuild;
  final void Function(String value)? onChanged;
  final BuildContext context;
  final List<SingleListPickerOption>? options;
  const SingleListPicker({
    super.key,
    this.title,
    this.disabled = false,
    this.isRequired = true,
    this.initialValue = '',
    this.validator,
    this.onChanged,
    this.hintText = 'Please Select',
    this.childBuild,
    this.options,
    required this.context,
  });

  @override
  State<SingleListPicker> createState() => _SingleListPickerState();

  static transformStringListToOptions(List<String> list) {
    return list.map((e) => SingleListPickerOption(label: e, value: e)).toList();
  }
}

class _SingleListPickerState extends State<SingleListPicker> {
  int _selectedIndex = 0;
  SingleListPickerOption? _selectedOption;

  void _onConfirm(index) {
    setState(() {
      _selectedIndex = index;
      _selectedOption = widget.options?[index];
      widget.onChanged?.call(_selectedOption!.value);
    });
  }

  void _initDefaultSelectedInfo() {
    if (widget.options == null || widget.options!.isEmpty) {
      return;
    }
    if (widget.initialValue != '') {
      for (var i = 0; i < widget.options!.length; i++) {
        if (widget.options![i].value == widget.initialValue) {
          _selectedOption = widget.options![i];
          _selectedIndex = i;
          return;
        }
      }
    }
    setState(() {
      _selectedIndex = 0;
      _selectedOption = widget.options!.first;
    });
    // widget.onChanged?.call(_selectedOption!.value);
  }

  @override
  void initState() {
    super.initState();
    _initDefaultSelectedInfo();
  }

  void _openPicker() {
    Picker(
      adapter: PickerDataAdapter(
        data: List.generate(
          widget.options!.length,
          (index) {
            return PickerItem(
              text: Center(
                child: Text(
                  widget.options![index].label,
                  style: TextStyle(
                    fontSize: pt(14, isFontSize: true),
                    height: 1,
                  ),
                ),
              ),
              value: widget.options![index].value,
            );
          },
        ),
      ),
      onConfirm: (picker, selected) {
        _onConfirm(selected[0]);
      },
      selecteds: [_selectedIndex],
      headerDecoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppSize.boxShadow,
      ),
      title: null,
      height: pt(180),
      itemExtent: pt(36),
      selectedTextStyle: TextStyle(color: AppColors.darkBlue),
      cancelTextStyle: const TextStyle(color: AppColors.nearlyBlack),
      confirmTextStyle: TextStyle(color: AppColors.darkBlue),
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
  }

  @override
  Widget build(BuildContext context) {
    if (widget.childBuild != null) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _openPicker,
        child: widget.childBuild!(_selectedOption?.value, _selectedOption),
      );
    }
    return GestureDetector(
      onTap: () {
        _openPicker();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: pt(44),
        padding: EdgeInsets.symmetric(
          horizontal: pt(10),
        ),
        decoration: BoxDecoration(
          color: const Color(0xffefefef),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _selectedOption != null
                  ? _selectedOption!.label
                  : widget.hintText,
              style: TextStyle(
                fontSize: pt(12, isFontSize: true),
                fontWeight: FontWeight.w500,
                color: Color(_selectedOption != null ? 0xff676767 : 0xff979797),
              ),
            ),
            SvgAsset(
              assetName: AssetsSvg.DOWN,
              width: pt(12, isFontSize: true),
              color: const Color(0xff676767),
            ),
          ],
        ),
      ),
    );
  }
}
