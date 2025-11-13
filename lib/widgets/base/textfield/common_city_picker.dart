import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_picker/picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

class CommonCityPickerFormField extends StatefulWidget {
  final String? hintText;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final bool isPasswordField;
  final TextEditingController? controller;
  final ValueChanged<List<dynamic>>? onChanged;
  final bool isPhoneNumberField;
  final Color? fillColor;
  final Color? borderColor;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final int? maxLines;
  final double? radius;
  final String? labelText;
  final Function(String)? onSubmitField;
  final int? maxLength;
  final bool? isRequiredLabel;
  final bool? isRequiredHint;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool? isCountryLabelVisible;
  final String? name;
  final String? Function(String?)? validators;
  final List<String>? initialCityData; // 新增：初始省市区数据 [provinceCode, cityCode, areaCode]

  const CommonCityPickerFormField({
    super.key,
    this.hintText,
    this.leadingIcon,
    this.isPasswordField = false,
    this.controller,
    this.onChanged,
    this.suffixIcon,
    this.isPhoneNumberField = false,
    this.fillColor,
    this.hintStyle,
    this.focusNode,
    this.borderColor,
    this.maxLines,
    this.labelText,
    this.onSubmitField,
    this.radius = 12,
    this.maxLength,
    this.isRequiredLabel,
    this.isRequiredHint,
    this.textAlign,
    this.textAlignVertical,
    this.isCountryLabelVisible = false,
    this.name,
    this.validators,
    this.initialCityData,
  });

  @override
  CommonCityPickerFormFieldState createState() =>
      CommonCityPickerFormFieldState();
}

class CommonCityPickerFormFieldState extends State<CommonCityPickerFormField> {
  late FocusNode _focusNode;

  List<dynamic> cityData = [];
  List<int> selectedIndexes = [0, 0, 0]; // 存储当前选中的索引

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(() {
      print('isFocused: $_focusNode');
      setState(() {});
    });

    loadJsonFromAssets().then((value) {
      setState(() {
        cityData = value;
        // 如果有初始值，计算对应的索引
        if (widget.initialCityData != null && widget.initialCityData!.length >= 3) {
          selectedIndexes = _findIndexesByCodes(
            widget.initialCityData![0],
            widget.initialCityData![1],
            widget.initialCityData![2],
          );
        }
      });
    });
  }

  /// 根据省市区代码查找对应的索引
  /// 遵循 KISS 原则，使用简单的遍历查找
  List<int> _findIndexesByCodes(String provinceCode, String cityCode, String areaCode) {
    int provinceIndex = 0;
    int cityIndex = 0;
    int areaIndex = 0;

    // 查找省份索引
    for (int i = 0; i < cityData.length; i++) {
      if (cityData[i]['code'] == provinceCode) {
        provinceIndex = i;
        // 查找城市索引
        final cities = cityData[i]['children'] as List<dynamic>;
        for (int j = 0; j < cities.length; j++) {
          if (cities[j]['code'] == cityCode) {
            cityIndex = j;
            // 查找区县索引
            final areas = cities[j]['children'] as List<dynamic>;
            for (int k = 0; k < areas.length; k++) {
              if (areas[k]['code'] == areaCode) {
                areaIndex = k;
                break;
              }
            }
            break;
          }
        }
        break;
      }
    }

    return [provinceIndex, cityIndex, areaIndex];
  }

  Future<List<dynamic>> loadJsonFromAssets() async {
    // 读取文件内容为字符串
    String jsonString =
        await rootBundle.loadString('assets/json/pca-code.json');

    // 解析为 Map
    final data = json.decode(jsonString);

    return data;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  showPicker(BuildContext context) {
    List<PickerItem> items = cityData.map<PickerItem>((item) {
      List<PickerItem> children1 =
          (item['children'] as List<dynamic>).map<PickerItem>((child) {
        List<PickerItem> children2 =
            (child['children'] as List<dynamic>).map<PickerItem>((grandChild) {
          return PickerItem(
            text: Text(grandChild['name']),
            value: grandChild['code'],
          );
        }).toList();
        return PickerItem(
          text: Text(child['name']),
          value: child['code'],
          children: children2,
        );
      }).toList();
      PickerItem pr = PickerItem(
        text: Text(item['name']),
        value: item['code'],
        children: children1,
      );
      return pr;
    }).toList();
    Picker(
      height: AppSizes.setHeight(280),
      itemExtent: AppSizes.setHeight(28),
      confirmText: '确定',
      cancelText: '取消',
      selecteds: selectedIndexes, // 设置默认选中的索引
      onConfirm: (Picker picker, List value) {
        final provinceCode = cityData[value[0]]['code'];
        final provinceName = cityData[value[0]]['name'];
        final cityCode = cityData[value[0]]['children'][value[1]]['code'];
        final cityName = cityData[value[0]]['children'][value[1]]['name'];
        final areaCode = cityData[value[0]]['children'][value[1]]['children']
            [value[2]]['code'];
        final areaName = cityData[value[0]]['children'][value[1]]['children']
            [value[2]]['name'];
        final text = '$provinceName $cityName $areaName';
        widget.controller?.text = text;

        // 更新当前选中的索引（遵循单一职责原则）
        setState(() {
          selectedIndexes = [value[0], value[1], value[2]];
        });

        widget.onChanged?.call([
          provinceName,
          cityName,
          areaName,
          provinceCode,
          cityCode,
          areaCode
        ]);
      },
      confirmTextStyle: TextStyle(
        color: CustomAppColor.of(context).txtBlue,
        fontSize: AppSizes.setFontSize(18),
        fontWeight: FontWeight.normal,
      ),
      cancelTextStyle: TextStyle(
        color: CustomAppColor.of(context).txtGrey,
        fontSize: AppSizes.setFontSize(18),
        fontWeight: FontWeight.normal,
      ),
      magnification: 1.1,
      headerDecoration: BoxDecoration(
        color: CustomAppColor.of(context).bgScaffold,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      adapter: PickerDataAdapter(
        data: items,
      ),
      title: const Text("选择地址"),
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isFocused = _focusNode.hasFocus;
    return FormBuilderTextField(
      name: widget.name ?? '',
      textAlign: widget.textAlign ?? TextAlign.start,
      textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.top,
      maxLength: widget.maxLength,
      focusNode: _focusNode,
      controller: widget.controller,
      maxLines: widget.maxLines ?? 1,
      readOnly: true,
      onTap: () {
        showPicker(context);
      },
      style: TextStyle(
        color: CustomAppColor.of(context).txtBlack,
        fontSize: AppSizes.setFontSize(14),
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: isFocused
            ? "${widget.hintText ?? widget.labelText ?? ""}${(widget.isRequiredLabel ?? false) ? " *" : ""}"
            : "${widget.labelText ?? ""}${(widget.isRequiredLabel ?? false) ? " *" : ""}",
        labelStyle: TextStyle(
            color: _focusNode.hasFocus
                ? CustomAppColor.of(context).borderPurple
                : CustomAppColor.of(context).txtGrey,
            fontSize: AppSizes.setFontSize(15),
            fontWeight: FontWeight.w600),
        fillColor: widget.fillColor ?? CustomAppColor.of(context).bgContainer,
        filled: true,
        hintText: isFocused
            ? null
            : "${widget.hintText ?? ""}${widget.isRequiredHint ?? false ? " *" : ""}",
        hintStyle: widget.hintStyle ??
            TextStyle(
                color: CustomAppColor.of(context).hintText,
                fontWeight: FontWeight.w400,
                fontSize: AppSizes.setFontSize(14)),
        prefixIcon: widget.leadingIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(12)),
                child: widget.leadingIcon,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: widget.radius != null
              ? BorderRadius.circular(widget.radius ?? 0)
              : BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.transparent, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: widget.radius != null
              ? BorderRadius.circular(widget.radius ?? 0)
              : BorderRadius.circular(8),
          borderSide: BorderSide(
              color:
                  widget.borderColor ?? CustomAppColor.of(context).borderGrey,
              width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: widget.radius != null
              ? BorderRadius.circular(widget.radius ?? 0)
              : BorderRadius.circular(8),
          borderSide: BorderSide(
              color:
                  widget.borderColor ?? CustomAppColor.of(context).borderPurple,
              width: 2),
        ),
      ),
      validator: widget.validators != null
          ? FormBuilderValidators.compose([widget.validators!])
          : FormBuilderValidators.required(
              errorText: '${widget.name} is required'),
    );
  }
}
