import 'package:flutter/material.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';

/// 彩票类型选择器组件
class LotteryTypeSelector extends StatelessWidget {
  final LotteryType selectedType;
  final ValueChanged<LotteryType> onChanged;
  final String title;

  const LotteryTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onChanged,
    this.title = '彩票类型',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: pt(16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: pt(12)),
          _buildTypeChips(),
        ],
      ),
    );
  }

  /// 构建类型选择chips
  Widget _buildTypeChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: LotteryType.values.map((type) {
        final isSelected = selectedType == type;
        return _buildTypeChip(type, isSelected);
      }).toList(),
    );
  }

  /// 构建单个类型chip
  Widget _buildTypeChip(LotteryType type, bool isSelected) {
    return GestureDetector(
      onTap: () => onChanged(type),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: pt(16), vertical: pt(8)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(pt(20)),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.check,
                  size: pt(16),
                  color: Colors.white,
                ),
              ),
            Text(
              type.displayName,
              style: TextStyle(
                fontSize: pt(14),
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
