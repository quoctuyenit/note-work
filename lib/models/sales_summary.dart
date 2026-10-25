import 'package:flutter/material.dart';

class EmployeeSalesSummary {
  final int employeeId;
  final String employeeName;
  final double totalAmount;
  final double percentage; // 0..100
  final Color color;

  EmployeeSalesSummary({
    required this.employeeId,
    required this.employeeName,
    required this.totalAmount,
    required this.percentage,
    required this.color,
  });
}

class SalesPeriodSummary {
  final int year;
  final int? month; // null nếu là cả năm
  final double grandTotal;
  final List<EmployeeSalesSummary> employeeSummaries;

  SalesPeriodSummary({
    required this.year,
    this.month,
    required this.grandTotal,
    required this.employeeSummaries,
  });

  bool get isEmpty => employeeSummaries.isEmpty || grandTotal <= 0;
}
