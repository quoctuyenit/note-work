import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_work/database/app_database.dart';
import 'package:note_work/repository/booking_repository.dart';
import 'package:note_work/ui/widgets/add_or_edit_sale_dialog.dart';
import 'package:note_work/ui/widgets/sales_record_item.dart';

class SalesDayItem extends StatefulWidget {
  final SalesDay day;
  final List<EmployeeSale> sales;
  final BookingRepository repo;
  final VoidCallback? onChanged;

  const SalesDayItem({
    super.key,
    required this.day,
    required this.sales,
    required this.repo,
    this.onChanged,
  });

  @override
  State<SalesDayItem> createState() => _SalesDayItemState();
}

class _SalesDayItemState extends State<SalesDayItem> {
  late bool _collapsed;
  final NumberFormat _currencyFmt = NumberFormat('#,###', 'vi_VN');

  @override
  void initState() {
    super.initState();
    _collapsed = widget.day.isCollapsed;
  }

  @override
  void didUpdateWidget(covariant SalesDayItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day.isCollapsed != widget.day.isCollapsed) {
      _collapsed = widget.day.isCollapsed;
    }
  }

  String _weekdayShortProper(int w) {
    switch (w) {
      case DateTime.monday:
        return 'T2';
      case DateTime.tuesday:
        return 'T3';
      case DateTime.wednesday:
        return 'T4';
      case DateTime.thursday:
        return 'T5';
      case DateTime.friday:
        return 'T6';
      case DateTime.saturday:
        return 'T7';
      default:
        return 'CN';
    }
  }

  String _dateTitle(DateTime d) {
    final wd = _weekdayShortProper(d.weekday);
    final dd = DateFormat('dd/MM').format(d);
    return '$wd - $dd';
  }

  String _formatCurrency(double amount) {
    return '${_currencyFmt.format(amount.round())} đ';
  }

  Future<void> _toggleCollapse() async {
    await widget.repo.toggleSalesDayCollapse(widget.day.id);
    setState(() => _collapsed = !_collapsed);
    widget.onChanged?.call();
  }

  Future<void> _editDate() async {
    final booked =
        await widget.repo.getSalesDateSet(excludeDayId: widget.day.id);

    final picked = await showDatePicker(
      context: context,
      initialDate: widget.day.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      selectableDayPredicate: (dt) {
        final dd = DateTime(dt.year, dt.month, dt.day);
        return !booked.contains(dd);
      },
    );
    if (picked == null) return;

    try {
      await widget.repo.updateSalesDayDate(widget.day.id, picked);
      widget.onChanged?.call();
    } catch (e) {
      final msg =
          (e is String) ? e : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  Future<void> _addSale() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) =>
          AddOrEditSaleDialog(repo: widget.repo, dayId: widget.day.id),
    );
    if (ok == true) widget.onChanged?.call();
  }

  Future<void> _editSale(EmployeeSale sale) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AddOrEditSaleDialog(
        repo: widget.repo,
        dayId: widget.day.id,
        existingSale: sale,
      ),
    );
    if (ok == true) widget.onChanged?.call();
  }

  Future<void> _deleteSale(EmployeeSale sale) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text('Bạn muốn xóa dòng dữ liệu của "${sale.employeeName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.repo.deleteSale(sale.id);
      widget.onChanged?.call();
    }
  }

  Future<void> _deleteDay() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa ngày'),
        content: Text(
          'Bạn có chắc chắn muốn xóa ngày ${_dateTitle(widget.day.date)} và toàn bộ dữ liệu của ngày này?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa ngày'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.repo.deleteSalesDay(widget.day.id);
      widget.onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.day;
    final sales = widget.sales;

    final now = DateTime.now();
    final isToday = day.date.year == now.year &&
        day.date.month == now.month &&
        day.date.day == now.day;

    final totalAmount = sales.fold<double>(0, (sum, s) => sum + s.amount);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isToday ? Colors.pink.shade300 : Colors.transparent,
          width: isToday ? 1.5 : 0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          children: [
            // Header ngày
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        _dateTitle(day.date),
                        style: TextStyle(
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.w600,
                          fontSize: 16,
                          color: isToday ? Colors.pink : null,
                        ),
                      ),
                      // Badge Tổng tiền trong ngày
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.pink.shade200),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '∑ = ${_formatCurrency(totalAmount)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink.shade700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: _collapsed ? 'Mở rộng' : 'Thu gọn',
                  icon:
                      Icon(_collapsed ? Icons.unfold_more : Icons.unfold_less),
                  onPressed: _toggleCollapse,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Đổi ngày',
                  icon: const Icon(Icons.edit_calendar),
                  onPressed: _editDate,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Thêm',
                  icon: const Icon(Icons.add, color: Colors.pink),
                  onPressed: _addSale,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Xóa',
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: _deleteDay,
                ),
              ],
            ),

            // Content: danh sách doanh số
            if (!_collapsed) ...[
              const Divider(height: 16),
              if (sales.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'Chưa có dữ liệu trong ngày này\nBấm nút (+) để thêm',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...sales.map((s) {
                  return SalesRecordItem(
                    sale: s,
                    onEdit: () => _editSale(s),
                    onDelete: () => _deleteSale(s),
                  );
                }),
            ],
          ],
        ),
      ),
    );
  }
}
