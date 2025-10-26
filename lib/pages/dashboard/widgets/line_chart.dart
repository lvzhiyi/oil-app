import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottery_app/pages/dashboard/model/dashboard_type.dart';
import 'package:lottery_app/utils/pt.dart';

/// 简单折线图绘制器
class LineChartPainter extends CustomPainter {
  final List<DashboardTrendsDataItem> data;
  final int maxValue;

  LineChartPainter({required this.data, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = <Offset>[];

    // 计算点的位置
    for (int i = 0; i < data.length; i++) {
      double x = ((size.width - 20) / (max(data.length, 2) - 1)) * i + 10;
      double y = data[i].count == 0
          ? size.height
          : size.height - (data[i].count / maxValue) * size.height;
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // 绘制折线
    canvas.drawPath(path, paint);

    // 绘制数据点
    for (int i = 0; i < points.length; i++) {
      // 绘制点
      canvas.drawCircle(points[i], 4.0, pointPaint);

      // 绘制数值标签
      final textPainter = TextPainter(
        text: TextSpan(
          text: data[i].count.toString(),
          style: TextStyle(
            color: Colors.blue,
            fontSize: pt(10),
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // 在点的上方绘制文字
      double textX = points[i].dx - textPainter.width / 2;
      double textY = points[i].dy - textPainter.height - 8;

      // 确保文字不超出边界
      textX = textX.clamp(0, size.width - textPainter.width);
      // textY = textY.clamp(0, size.height - textPainter.height);

      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return data != oldDelegate.data || maxValue != oldDelegate.maxValue;
  }
}
