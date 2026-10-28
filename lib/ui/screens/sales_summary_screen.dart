import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:note_work/models/sales_summary.dart';
import 'package:note_work/providers/booking_provider.dart';
import 'package:note_work/ui/widgets/ios_month_year_picker.dart';
import 'package:note_work/ui/widgets/sales_pie_chart.dart';

class SalesSummaryScreen extends ConsumerStatefulWidget {
  const SalesSummaryScreen({super.key});

  @override
  ConsumerState<SalesSummaryScreen> createState() => _SalesSummaryScreenState();
}

class _SalesSummaryScreenState extends ConsumerState<SalesSummaryScreen> {
  late int _selectedYear;
  int? _selectedMonth;
  int? _selectedEmployeeId;
  final Set<int> _expandedEmployeeIds = {};

  final NumberFormat _currencyFmt = NumberFormat('#,###', 'vi_VN');

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
  }

  String _formatCurrency(double amount) {
    return '${_currencyFmt.format(amount.round())} đ';
  }

  String _formatPercent(double pct) {
    final fixed = pct.toStringAsFixed(1);
    final cleaned = fixed.endsWith('.0')
        ? fixed.substring(0, fixed.length - 2)
        : fixed.replaceAll('.', ',');
    return '$cleaned %';
  }

  void _prevPeriod() {
    setState(() {
      if (_selectedMonth != null) {
        if (_selectedMonth == 1) {
          _selectedMonth = 12;
          _selectedYear--;
        } else {
          _selectedMonth = _selectedMonth! - 1;
        }
      } else {
        _selectedYear--;
      }
      _selectedEmployeeId = null;
      _expandedEmployeeIds.clear();
    });
  }

  void _nextPeriod() {
    final maxYear = DateTime.now().year + 1;
    setState(() {
      if (_selectedMonth != null) {
        if (_selectedMonth == 12) {
          if (_selectedYear < maxYear) {
            _selectedMonth = 1;
            _selectedYear++;
          }
        } else {
          if (_selectedYear < maxYear || _selectedMonth! < 12) {
            _selectedMonth = _selectedMonth! + 1;
          }
        }
      } else {
        if (_selectedYear < maxYear) {
          _selectedYear++;
        }
      }
      _selectedEmployeeId = null;
      _expandedEmployeeIds.clear();
    });
  }

  Future<void> _openPicker() async {
    final result = await showIosMonthYearPicker(
      context: context,
      initialYear: _selectedYear,
      initialMonth: _selectedMonth,
      allowYearOnly: true,
    );

    if (result != null) {
      setState(() {
        _selectedYear = result.year;
        _selectedMonth = result.month;
        _selectedEmployeeId = null;
        _expandedEmployeeIds.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filter = SalesSummaryFilter(
      year: _selectedYear,
      month: _selectedMonth,
    );
    final summaryAsync = ref.watch(salesSummaryProvider(filter));

    final String periodLabel = _selectedMonth != null
        ? 'Tháng $_selectedMonth / $_selectedYear'
        : 'Cả Năm $_selectedYear';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tổng hợp doanh số'),
        actions: [
          IconButton(
            tooltip: 'Làm mới',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(salesSummaryProvider(filter));
            },
          ),
        ],
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
          ),
        ),
        data: (summary) {
          final summaries = summary.employeeSummaries;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header điều hướng thời gian
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.pink.shade100),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Kỳ trước',
                        icon: const Icon(Icons.chevron_left, size: 28),
                        onPressed: _prevPeriod,
                      ),
                      InkWell(
                        onTap: _openPicker,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.pink.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 18,
                                color: Colors.pink,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                periodLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.pink,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 18,
                                color: Colors.pink,
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Kỳ sau',
                        icon: const Icon(Icons.chevron_right, size: 28),
                        onPressed: _nextPeriod,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Card Biểu đồ tròn
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SalesPieChart(
                          summary: summary,
                          selectedEmployeeId: _selectedEmployeeId,
                          onEmployeeSelected: (id) {
                            setState(() {
                              _selectedEmployeeId = id;
                              if (id != null) {
                                _expandedEmployeeIds.add(id);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tiêu đề danh sách
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chi tiết theo nhân viên',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${summaries.length} nhân viên',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Danh sách từng dòng nhân viên
                if (summaries.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    alignment: Alignment.center,
                    child: Text(
                      'Không có dữ liệu trong kỳ $periodLabel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  )
                else
                  ...summaries.asMap().entries.map((entry) {
                    final index = entry.key;
                    final emp = entry.value;
                    final isExpanded =
                        _expandedEmployeeIds.contains(emp.employeeId);

                    return _buildEmployeeCard(
                      emp: emp,
                      rank: index + 1,
                      isExpanded: isExpanded,
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedEmployeeIds.remove(emp.employeeId);
                            if (_selectedEmployeeId == emp.employeeId) {
                              _selectedEmployeeId = null;
                            }
                          } else {
                            _expandedEmployeeIds.add(emp.employeeId);
                            _selectedEmployeeId = emp.employeeId;
                          }
                        });
                      },
                    );
                  }),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmployeeCard({
    required EmployeeSalesSummary emp,
    required int rank,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    final initial = emp.employeeName.trim().isNotEmpty
        ? emp.employeeName.trim()[0].toUpperCase()
        : '?';

    // Huy hiệu thứ hạng (#1 vàng, #2 bạc, #3 đồng)
    Widget rankBadge;
    if (rank == 1) {
      rankBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.amber.shade600),
        ),
        child: const Text(
          '#1',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      );
    } else if (rank == 2) {
      rankBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.blueGrey.shade300),
        ),
        child: const Text(
          '#2',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      );
    } else if (rank == 3) {
      rankBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: const Text(
          '#3',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
      );
    } else {
      rankBadge = Text(
        '#$rank',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: isExpanded ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isExpanded ? emp.color : Colors.grey.shade200,
          width: isExpanded ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Cột thứ hạng (chỉ hiển thị #1, #2, #3...)
                  SizedBox(
                    width: 34,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: rankBadge,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Avatar nhân viên mang màu của biểu đồ
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: emp.color.withValues(alpha: 0.18),
                    foregroundColor: emp.color,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tên & Thanh phần trăm
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Biểu tượng workspace_premium đặt ở trước tên nhân viên top 1
                            if (rank == 1) ...[
                              const Icon(
                                Icons.workspace_premium,
                                size: 18,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                emp.employeeName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (emp.percentage / 100).clamp(0.0, 1.0),
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade100,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(emp.color),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Số tiền & Tỷ lệ %
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatCurrency(emp.totalAmount),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: emp.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _formatPercent(emp.percentage),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: emp.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),

                  // Icon chỉ báo mở rộng
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: isExpanded ? emp.color : Colors.grey.shade400,
                  ),
                ],
              ),

              // Phần xổ xuống: Chi tiết các loại doanh số phát sinh
              if (isExpanded) ...[
                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  thickness: 0.8,
                  color: Colors.grey.shade200,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Chi tiết theo loại doanh số:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (emp.categoryBreakdown.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Chưa có phân loại doanh số cụ thể',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  )
                else
                  ...emp.categoryBreakdown.map((cat) {
                    final isNail = cat.categoryName.toLowerCase() == 'nail';
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isNail
                                  ? Colors.purple.shade50
                                  : Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isNail
                                    ? Colors.purple.shade200
                                    : Colors.teal.shade200,
                              ),
                            ),
                            child: Text(
                              cat.categoryName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isNail
                                    ? Colors.purple.shade700
                                    : Colors.teal.shade700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatCurrency(cat.amount),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border:
                                  Border.all(color: Colors.pink.shade100),
                            ),
                            child: Text(
                              _formatPercent(cat.percentage),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
