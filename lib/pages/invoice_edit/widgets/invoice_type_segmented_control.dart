import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

class InvoiceTypeSegmentedControl extends StatelessWidget {
  final String? selectedType;
  final Function(String) onTypeChanged;

  const InvoiceTypeSegmentedControl({
    Key? key,
    required this.selectedType,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final types = [
      {'value': 'general_vat', 'label': '增值税普通发票'},
      {'value': 'special_vat', 'label': '增值税专用发票'},
    ];

    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(4)),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
      ),
      child: Row(
        children: types.map((type) {
          final isSelected = selectedType == type['value'];
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTypeChanged(type['value']!),
                splashColor: Colors.transparent,
                // highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(AppSizes.setWidth(6)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.setHeight(8),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSizes.setWidth(6)),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      style: TextStyle(
                        fontSize: AppSizes.setFontSize(13),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF7165E3)
                            : const Color(0xFF6B7280),
                      ),
                      child: Text(type['label']!),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
