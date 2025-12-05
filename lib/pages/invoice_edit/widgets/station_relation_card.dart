import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

class StationRelationCard extends StatelessWidget {
  final String stationName;

  const StationRelationCard({
    Key? key,
    required this.stationName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(16),
        vertical: AppSizes.setHeight(12),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEEECFC),
        border: Border.all(
          color: const Color(0xFF7165E3).withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.link,
            size: AppSizes.setWidth(16),
            color: const Color(0xFF7165E3),
          ),
          SizedBox(width: AppSizes.setWidth(8)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: AppSizes.setFontSize(13),
                  color: const Color(0xFF7165E3),
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  const TextSpan(text: '关联加油站：'),
                  TextSpan(
                    text: stationName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
