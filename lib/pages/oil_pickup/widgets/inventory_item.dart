import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/pt.dart';

class InventoryItem extends StatelessWidget {
  final InventoryModel inventory;
  final VoidCallback? onTap;

  const InventoryItem({
    Key? key,
    required this.inventory,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final depotName = inventory.depotName ?? '';
    final fuelType = inventory.fuelType ?? '';
    final availableInventory = inventory.availableTon ?? 0.0;
    final isOutOfStock = availableInventory <= 0;

    // Parse fuel type: "#95汽油" -> code: "#95", name: "汽油"
    String code = '';
    String name = fuelType;
    if (fuelType.contains('#')) {
      final parts = fuelType.split('#');
      if (parts.length > 1) {
        // Case: "95#汽油" -> ["95", "汽油"] (if split by #?)
        // Wait, split works differently.
        // If "#95汽油", split('#') -> ["", "95汽油"] - not good.
        // Let's assume standard format or regex.
        
        // Simple logic: extract digits and # as code, rest as name.
        final match = RegExp(r'([#0-9]+)(.*)').firstMatch(fuelType);
        if (match != null) {
          code = match.group(1) ?? '';
          name = match.group(2) ?? '';
        } else {
            // fallback
           code = fuelType.substring(0, min(fuelType.length, 3)); 
           name = fuelType.substring(min(fuelType.length, 3));
        }
      }
    } else {
         // Try to match digits at start
         final match = RegExp(r'^([0-9]+)(.*)').firstMatch(fuelType);
         if (match != null) {
             code = '#${match.group(1)}';
             name = match.group(2) ?? '';
         } else {
            // e.g. "柴油" -> code: "0#", name: "柴油" ? No assumption.
            // just use first 2 chars as code
             if (fuelType.length > 2) {
                 code = fuelType.substring(0, 2);
                 name = fuelType.substring(2);
             } else {
                 code = fuelType;
                 name = '';
             }
         }
    }
    
    // Refined parsing logic based on examples "#95 汽油" or "95#汽油"
    // Example HTML shows: code="#95", name="汽油"
    // If data is "95#汽油", I want code="95#", name="汽油" or similar.
    // Let's keep it simple: split by non-digit/non-hash if possible, or just manual fix.
    // Better approach for now:
    if (fuelType.contains('#')) {
        int index = fuelType.indexOf('#');
        // Check if # is at start or middle
        if (index == 0) {
            // #95汽油
             final match = RegExp(r'^(#[0-9]+)(.*)').firstMatch(fuelType);
             if (match != null) {
                 code = match.group(1)!;
                 name = match.group(2)!;
             }
        } else {
            // 95#汽油
             final match = RegExp(r'^([0-9]+#)(.*)').firstMatch(fuelType);
             if (match != null) {
                 code = match.group(1)!;
                 name = match.group(2)!;
             }
        }
    }
    if (code.isEmpty && name.isEmpty) {
         name = fuelType;
    }

    final themeColor = CustomAppColor.of(context).btnPurple;
    
    return Container(
      margin: EdgeInsets.only(bottom: pt(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.06),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: pt(16), vertical: pt(12)),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFF5F5F5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined, // Using built-in icon instead of asset for simplicity if suitable
                  size: pt(14),
                  color: const Color(0xFFCCCCCC),
                ),
                Gap(pt(6)),
                Text(
                  depotName,
                  style: TextStyle(
                    fontSize: pt(15),
                    fontWeight: FontWeight.bold,
                    color: CustomAppColor.of(context).txtBlack,
                  ),
                ),
              ],
            ),
          ),
          
          // Body
          Padding(
            padding: EdgeInsets.all(pt(16)),
            child: Row(
              children: [
                // Left: Symbol
                Container(
                  width: pt(56),
                  height: pt(56),
                  decoration: BoxDecoration(
                    color: isOutOfStock 
                        ? const Color(0xFFF5F5F5) 
                        : themeColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        code,
                        style: TextStyle(
                          fontSize: pt(20),
                          fontWeight: FontWeight.w900,
                          color: isOutOfStock ? const Color(0xFFAAAAAA) : themeColor,
                          height: 1.0,
                        ),
                      ),
                      if (name.isNotEmpty) ...[
                        Gap(pt(4)),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: pt(10),
                            fontWeight: FontWeight.w500,
                            color: isOutOfStock ? const Color(0xFFAAAAAA) : themeColor.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                Gap(pt(16)),
                
                // Middle: Stock
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '当前持有',
                        style: TextStyle(
                          fontSize: pt(12),
                          color: CustomAppColor.of(context).txtGrey,
                        ),
                      ),
                      Gap(pt(2)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${availableInventory.toInt()}',
                            style: TextStyle(
                              fontFamily: 'Roboto', // Using Roboto as fallback for DIN
                              fontSize: pt(24),
                              fontWeight: FontWeight.bold,
                              color: isOutOfStock ? const Color(0xFFCCCCCC) : CustomAppColor.of(context).txtBlack,
                            ),
                          ),
                          Gap(pt(2)),
                          Text(
                            '吨',
                            style: TextStyle(
                              fontSize: pt(12),
                              color: CustomAppColor.of(context).txtGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Right: Button
                Material(
                  color: isOutOfStock ? const Color(0xFFEEEEEE) : themeColor,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    onTap: isOutOfStock ? null : onTap,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: pt(36),
                      padding: EdgeInsets.symmetric(horizontal: pt(20)),
                      alignment: Alignment.center,
                      child: Text(
                        isOutOfStock ? '暂无库存' : '去提油',
                        style: TextStyle(
                          fontSize: pt(13),
                          fontWeight: FontWeight.w600,
                          color: isOutOfStock ? const Color(0xFFBBBBBB) : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  int min(int a, int b) => a < b ? a : b;
}
