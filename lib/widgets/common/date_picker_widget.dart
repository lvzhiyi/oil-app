import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/utils/hex_color.dart';
import 'package:lottery_app/utils/pt.dart';

class DatePickerWidget extends StatefulWidget {
  final int year;
  final int month;
  final int day;
  final void Function(String) onChange;

  /// 日期选择器部件，允许用户选择年、月、日
  ///
  /// - [year] 年，默认1980年
  /// - [month] 月，默认10月
  /// - [day] 日，默认10日
  /// - [onChange] 修改日期回调
  const DatePickerWidget({
    super.key,
    this.year = 1980,
    this.month = 10,
    this.day = 10,
    required this.onChange,
  });

  @override
  State<StatefulWidget> createState() => _DatePickerWidget();
}

class _DatePickerWidget extends State<DatePickerWidget> {
  /// 当前选择的日期
  late DateTime dateTime;

  /// 年、月、日列表，用于滚轮选择器展示
  late List<String> yearList;
  late List<String> monthList;
  late List<String> dayList;

  /// 当前选择的年、月、日对应的索引
  late int yearIndex;
  late int monthIndex;
  late int dayIndex;

  @override
  void initState() {
    super.initState();

    /// 初始化日期，根据传入的year, month, day判断
    if (widget.year != -1 && widget.month != -1 && widget.day != -1) {
      dateTime = DateTime(widget.year, widget.month, widget.day);
    } else {
      dateTime = DateTime.now();
    }

    /// 初始化年、月、日数据
    yearList = List.generate(200, (index) => (1900 + index + 1).toString());
    monthList = List.generate(12, (index) {
      return index + 1 >= 10 ? (index + 1).toString() : '0${index + 1}';
    });
    dayList =
        List.generate(daysInMonth(dateTime.year, dateTime.month), (index) {
      return index + 1 >= 10 ? (index + 1).toString() : '0${index + 1}';
    });

    /// 初始化年、月、日索引
    yearIndex = dateTime.year - 1900 - 1;
    monthIndex = dateTime.month - 1;
    dayIndex = dateTime.day - 1;
  }

  /// 计算某年某月的天数
  int daysInMonth(int year, int month) {
    final DateTime date = DateTime(year, month + 1, 0);
    return date.day;
  }

  /// 当选择的年、月、日发生变化时，更新对应的索引和日期列表。
  void onSelectedChange(yIndex, mIndex, dIndex) {
    /// 如果年或月发生变化，重新计算当月的天数
    if (yIndex != yearIndex || mIndex != monthIndex) {
      List<String> list = List.generate(
          daysInMonth(
              int.parse(yearList[yIndex]), int.parse(monthList[mIndex])),
          (index) {
        return index + 1 >= 10 ? (index + 1).toString() : '0${index + 1}';
      });
      if (dayIndex + 1 > list.length) {
        dIndex = list.length - 1;
      }

      /// 更新天数列表
      setState(() {
        dayList = list;
      });
    }

    /// 更新年、月、日索引
    setState(() {
      yearIndex = yIndex;
      monthIndex = mIndex;
      dayIndex = dIndex;
    });

    /// 调用回调函数，返回选定的日期
    widget.onChange(
      '${yearList[yIndex].toString()}-${monthList[mIndex].toString()}-${dayList[dIndex].toString()}',
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = double.infinity;
    double height = pt(130);

    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          children: [
            /// 月份选择器
            Expanded(
                child: WheelScrollItem(
              height: height,
              data: monthList,
              initValue: monthIndex,
              onSelectedChange: (value) =>
                  onSelectedChange(yearIndex, value, dayIndex),
            )),

            /// 日期选择器
            Expanded(
                child: WheelScrollItem(
              height: height,
              data: dayList,
              initValue: dayIndex,
              onSelectedChange: (value) =>
                  onSelectedChange(yearIndex, monthIndex, value),
            )),

            /// 年份选择器
            Expanded(
                child: WheelScrollItem(
              height: height,
              data: yearList,
              initValue: yearIndex,
              onSelectedChange: (value) =>
                  onSelectedChange(value, monthIndex, dayIndex),
            )),
          ],
        ),
      ),
    );
  }
}

/// 滚轮选择器部件，用于选择年、月、日。
class WheelScrollItem extends StatefulWidget {
  /// 滚轮的高度
  final double height;

  /// 显示的数据列表
  final List<String> data;

  /// 初始选择的索引
  final int initValue;

  /// 选择改变时的回调函数
  final Function onSelectedChange;

  const WheelScrollItem({
    super.key,
    required this.height,
    required this.data,
    required this.initValue,
    required this.onSelectedChange,
  });

  @override
  State<StatefulWidget> createState() => _WheelScrollItem();
}

class _WheelScrollItem extends State<WheelScrollItem> {
  /// 滚轮控制器，用于控制选择器的滚动行为
  final FixedExtentScrollController _controller = FixedExtentScrollController();

  /// 每一项的高度
  final itemHeight = pt(40);

  /// 当前选择的索引
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    /// 添加监听器，监控滚轮的滚动行为
    _controller.addListener(() {
      setState(() {
        currentIndex = _controller.selectedItem;
      });
    });

    currentIndex = widget.initValue;
    autoScrollToIndex();
  }

  @override
  void dispose() {
    /// 销毁控制器，释放资源
    _controller.dispose();
    super.dispose();
  }

  /// 自动滚动到指定索引
  void autoScrollToIndex() {
    Future.delayed(Duration.zero, () {
      _controller.animateTo(
        currentIndex * itemHeight as double,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      widget.onSelectedChange(currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: Stack(
        children: [
          /// 中间选中的区域
          Positioned(
            top: (widget.height - itemHeight) / 2,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: itemHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(pt(8)),
                color: HexColor('#f2f3f6'),
              ),
            ),
          ),

          /// 滚轮选择器的实现
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) {
                autoScrollToIndex();
              }
              return true;
            },
            child: Scrollable(
              axisDirection: AxisDirection.down,
              physics: const BouncingScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              viewportBuilder: (ctx, position) => ListWheelScrollView(
                  controller: _controller,
                  itemExtent: itemHeight,
                  perspective: 0.01,
                  overAndUnderCenterOpacity: 0.5,
                  useMagnifier: true,
                  magnification: 1.1,
                  children: widget.data.map(
                    (value) {
                      return SizedBox(
                        height: itemHeight,
                        child: Center(
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: pt(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList()),
            ),
          ),
        ],
      ),
    );
  }
}
