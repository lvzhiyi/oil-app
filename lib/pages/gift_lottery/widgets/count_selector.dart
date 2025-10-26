import 'package:flutter/material.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';

/// 数量选择器组件
class CountSelector extends StatelessWidget {
  final int selectedCount;
  final ValueChanged<int> onChanged;
  final List<int> options;
  final String label;

  const CountSelector({
    Key? key,
    required this.selectedCount,
    required this.onChanged,
    this.options = const [10, 20, 50, 100],
    this.label = '生成数量：',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: pt(14),
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: pt(8)),
        Expanded(
          child: Wrap(
            spacing: 8,
            children: options.map((count) {
              final isSelected = selectedCount == count;
              return GestureDetector(
                onTap: () => onChanged(count),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: pt(12), vertical: pt(6)),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.grey[100],
                    borderRadius: BorderRadius.circular(pt(16)),
                    border: isSelected
                        ? Border.all(color: AppColors.primary)
                        : null,
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: pt(12),
                      color:
                          isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
