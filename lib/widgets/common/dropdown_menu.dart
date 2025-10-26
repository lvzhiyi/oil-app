import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/resources/colors.dart';

class LotteryDropdownMenu<T> extends StatelessWidget {
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?) onChanged;
  final IconData? icon;
  final double? width;
  const LotteryDropdownMenu(
      {super.key,
      required this.hintText,
      required this.items,
      required this.value,
      required this.onChanged,
      this.icon,
      this.width});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isDense: true,
        dropdownStyleData: DropdownStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        isExpanded: true,
        hint: Row(
          children: [
            Icon(
              icon ?? Icons.list,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                hintText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items,
        value: value,
        onChanged: (T? value) {
          onChanged(value);
        },
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: width ?? 120,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
