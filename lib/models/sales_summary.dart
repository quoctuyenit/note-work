import 'package:flutter/material.dart';

class CategorySalesSummary {
  final String categoryName;
  final double amount;
  final double percentage; // 0..100 so với tổng doanh số của nhân viên đó

  CategorySalesSummary({
    required this.categoryName,
    required this.amount,
    required this.percentage,
  });
}

class EmployeeSalesSummary {
  final int employeeId;
  final String employeeName;
  final double totalAmount;
  final double percentage; // 0..100
  final Color color;
  final List<CategorySalesSummary> categoryBreakdown;

  EmployeeSalesSummary({
    required this.employeeId,
    required this.employeeName,
    required this.totalAmount,
    required this.percentage,
    required this.color,
    this.categoryBreakdown = const [],
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
