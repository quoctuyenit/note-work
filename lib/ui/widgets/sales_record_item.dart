import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_work/database/app_database.dart';

class SalesRecordItem extends StatelessWidget {
  final EmployeeSale sale;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SalesRecordItem({
    super.key,
    required this.sale,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatCurrency(double amount) {
    final fmt = NumberFormat('#,###', 'vi_VN');
    return '${fmt.format(amount.round())} đ';
  }

  @override
  Widget build(BuildContext context) {
    final initial = sale.employeeName.trim().isNotEmpty
        ? sale.employeeName.trim()[0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.pink.shade50),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.pink.shade100,
            foregroundColor: Colors.pink.shade800,
            child: Text(
              initial,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      sale.employeeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.pink.shade100),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _formatCurrency(sale.amount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (sale.note != null && sale.note!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Ghi chú: ${sale.note}',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                tooltip: 'Sửa',
                icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blueGrey),
                onPressed: onEdit,
              ),
              const SizedBox(width: 4),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                tooltip: 'Xóa',
                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
