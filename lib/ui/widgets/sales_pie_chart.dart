import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_work/models/sales_summary.dart';

class SalesPieChart extends StatefulWidget {
  final SalesPeriodSummary summary;
  final ValueChanged<int?>? onEmployeeSelected;
  final int? selectedEmployeeId;

  const SalesPieChart({
    super.key,
    required this.summary,
    this.onEmployeeSelected,
    this.selectedEmployeeId,
  });

  @override
  State<SalesPieChart> createState() => _SalesPieChartState();
}

class _SalesPieChartState extends State<SalesPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  final NumberFormat _currencyFmt = NumberFormat('#,###', 'vi_VN');

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant SalesPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.summary.year != widget.summary.year ||
        oldWidget.summary.month != widget.summary.month ||
        oldWidget.summary.grandTotal != widget.summary.grandTotal) {
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    return '${_currencyFmt.format(amount.round())} đ';
  }

  @override
  Widget build(BuildContext context) {
    final summaries = widget.summary.employeeSummaries;
    final total = widget.summary.grandTotal;

    if (summaries.isEmpty || total <= 0) {
      // Empty state
      return Center(
        child: Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade200, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.analytics_outlined, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                'Chưa có dữ liệu\ntrong kỳ này',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Center(
          child: SizedBox(
            width: 260,
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Custom Paint Donut Pie
                CustomPaint(
                  size: const Size(260, 260),
                  painter: _PieChartPainter(
                    summaries: summaries,
                    progress: _animation.value,
                    selectedEmployeeId: widget.selectedEmployeeId,
                  ),
                ),

                // Center Donut Hole content
                Container(
                  width: 136,
                  height: 136,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'TỔNG DOANH THU',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _formatCurrency(total),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<EmployeeSalesSummary> summaries;
  final double progress;
  final int? selectedEmployeeId;

  _PieChartPainter({
    required this.summaries,
    required this.progress,
    this.selectedEmployeeId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (summaries.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.58;

    double startAngle = -math.pi / 2; // Bắt đầu từ 12 giờ

    final totalAmount = summaries.fold<double>(0.0, (sum, e) => sum + e.totalAmount);
    if (totalAmount <= 0) return;

    final separatorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final hasMultipleSlices = summaries.length > 1;

    for (final emp in summaries) {
      final ratio = emp.totalAmount / totalAmount;
      if (ratio <= 0) continue;

      final isFullCircle = ratio >= 0.9999;
      final sweepAngle = ratio * 2 * math.pi * progress;
      final isSelected = selectedEmployeeId == emp.employeeId;

      final sliceRadius = isSelected ? outerRadius + 4 : outerRadius;
      final slicePaint = Paint()
        ..color = emp.color
        ..style = PaintingStyle.fill;

      if (isFullCircle && progress >= 0.999) {
        // Trường hợp chỉ có 1 nhân viên (hoặc 1 nhân viên chiếm 100%) khi animation kết thúc:
        // Vẽ toàn bộ vòng donut bằng 2 đường tròn đồng tâm với PathFillType.evenOdd
        // để tránh lỗi Skia/Impeller nuốt mất hình vẽ khi góc arcTo == 2*pi (360 độ).
        final path = Path()
          ..addOval(Rect.fromCircle(center: center, radius: sliceRadius))
          ..addOval(Rect.fromCircle(center: center, radius: innerRadius))
          ..fillType = PathFillType.evenOdd;

        canvas.drawPath(path, slicePaint);
      } else {
        // Giới hạn sweepAngle tối đa không chạm 2*pi để arcTo luôn hợp lệ và không bị suy biến
        final clampedSweep = math.min(sweepAngle, 2 * math.pi - 0.001);

        final path = Path()
          ..arcTo(
            Rect.fromCircle(center: center, radius: sliceRadius),
            startAngle,
            clampedSweep,
            false,
          )
          ..arcTo(
            Rect.fromCircle(center: center, radius: innerRadius),
            startAngle + clampedSweep,
            -clampedSweep,
            false,
          )
          ..close();

        canvas.drawPath(path, slicePaint);

        if (hasMultipleSlices && !isFullCircle) {
          canvas.drawPath(path, separatorPaint);
        }
      }

      // Vẽ nhãn % lên lát cắt nếu góc đủ rộng (>= 18 độ) và progress gần hoàn thành
      if (sweepAngle >= 0.32 && progress > 0.8) {
        final midAngle = startAngle + sweepAngle / 2;
        final labelRadius = (innerRadius + sliceRadius) / 2;
        final labelX = center.dx + labelRadius * math.cos(midAngle);
        final labelY = center.dy + labelRadius * math.sin(midAngle);

        final fixedPct = emp.percentage.toStringAsFixed(1);
        final cleanedPct = fixedPct.endsWith('.0')
            ? fixedPct.substring(0, fixedPct.length - 2)
            : fixedPct.replaceAll('.', ',');
        final pctText = '$cleanedPct%';
        final textPainter = TextPainter(
          text: TextSpan(
            text: pctText,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          textDirection: ui.TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedEmployeeId != selectedEmployeeId ||
        oldDelegate.summaries != summaries;
  }
}
