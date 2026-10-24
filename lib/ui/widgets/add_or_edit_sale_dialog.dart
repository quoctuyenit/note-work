import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_work/database/app_database.dart';
import 'package:note_work/repository/booking_repository.dart';
import 'package:note_work/ui/widgets/calculator_sheet.dart';

class AddOrEditSaleDialog extends StatefulWidget {
  final BookingRepository repo;
  final String dayId;
  final EmployeeSale? existingSale;

  const AddOrEditSaleDialog({
    super.key,
    required this.repo,
    required this.dayId,
    this.existingSale,
  });

  @override
  State<AddOrEditSaleDialog> createState() => _AddOrEditSaleDialogState();
}

class _AddOrEditSaleDialogState extends State<AddOrEditSaleDialog> {
  final NumberFormat _currencyFmt = NumberFormat('#,###', 'vi_VN');

  List<Employee> _employees = [];
  bool _loadingEmployees = true;

  Employee? _selectedEmployee;
  double _amount = 0;
  final TextEditingController _amountCtl = TextEditingController();
  final TextEditingController _noteCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _amountCtl.dispose();
    _noteCtl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final list = await widget.repo.getEmployees();
    setState(() {
      _employees = list;
      _loadingEmployees = false;

      if (widget.existingSale != null) {
        final s = widget.existingSale!;
        _amount = s.amount;
        _amountCtl.text = _formatCurrency(s.amount);
        _noteCtl.text = s.note ?? '';

        try {
          _selectedEmployee = list.firstWhere((e) => e.id == s.employeeId);
        } catch (_) {
          if (list.isNotEmpty) _selectedEmployee = list.first;
        }
      } else if (list.isNotEmpty) {
        _selectedEmployee = list.first;
      }
    });
  }

  String _formatCurrency(double amount) {
    if (amount <= 0) return '';
    return '${_currencyFmt.format(amount.round())} đ';
  }

  Future<void> _openCalculator() async {
    FocusScope.of(context).unfocus();
    final result = await CalculatorSheet.show(
      context,
      initialValue: _amount > 0 ? _amount : null,
    );
    if (result != null) {
      setState(() {
        _amount = result;
        _amountCtl.text = _formatCurrency(result);
      });
    }
  }

  Future<void> _save() async {
    if (_selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn nhân viên')),
      );
      return;
    }

    if (_amount <= 0) {
      // If amountCtl has raw number, try parsing
      final rawNum =
          double.tryParse(_amountCtl.text.replaceAll(RegExp(r'[^0-9]'), ''));
      if (rawNum != null && rawNum > 0) {
        _amount = rawNum;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ (> 0)')),
        );
        return;
      }
    }

    final note = _noteCtl.text.trim();

    try {
      if (widget.existingSale == null) {
        // Add new
        await widget.repo.addSaleToDay(
          widget.dayId,
          employeeId: _selectedEmployee!.id,
          employeeName: _selectedEmployee!.name,
          amount: _amount,
          note: note.isEmpty ? null : note,
        );
      } else {
        // Update
        await widget.repo.updateSale(
          widget.existingSale!.id,
          employeeId: _selectedEmployee!.id,
          employeeName: _selectedEmployee!.name,
          amount: _amount,
          note: note.isEmpty ? null : note,
        );
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      final msg =
          (e is String) ? e : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingSale != null;

    return AlertDialog(
      title: Row(
        children: [
          Icon(isEdit ? Icons.edit_note : Icons.add_chart, color: Colors.pink),
          const SizedBox(width: 8),
          Text(isEdit ? 'Sửa doanh số' : 'Thêm doanh số'),
        ],
      ),
      content: _loadingEmployees
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_employees.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: const Text(
                        'Chưa có nhân viên nào trong hệ thống. Vui lòng vào Cài đặt -> Nhân viên để thêm nhân viên trước.',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    )
                  else ...[
                    // Chọn nhân viên
                    DropdownButtonFormField<Employee>(
                      initialValue: _selectedEmployee,
                      decoration: const InputDecoration(
                        labelText: 'Nhân viên',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      items: _employees.map((emp) {
                        return DropdownMenuItem<Employee>(
                          value: emp,
                          child: Text(emp.name),
                        );
                      }).toList(),
                      onChanged: (emp) =>
                          setState(() => _selectedEmployee = emp),
                    ),
                    const SizedBox(height: 16),

                    // Nhập số tiền (có tích hợp Calculator UI)
                    InkWell(
                      onTap: _openCalculator,
                      borderRadius: BorderRadius.circular(4),
                      child: InputDecorator(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          labelText: 'Số tiền doanh số',
                          hintText: 'Bấm để mở máy tính tính tiền',
                          prefixIcon: const Icon(Icons.payments_outlined),
                          suffixIcon: IconButton(
                            tooltip: 'Mở máy tính',
                            icon: const Icon(Icons.calculate, color: Colors.pink),
                            onPressed: _openCalculator,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        child: Container(
                          height: 48,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _amountCtl.text.isEmpty
                                ? 'Bấm để mở bàn phím tính tiền'
                                : _amountCtl.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: _amountCtl.text.isEmpty
                                  ? Colors.grey.shade600
                                  : Colors.black87,
                              fontWeight: _amountCtl.text.isEmpty
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ghi chú
                    TextField(
                      controller: _noteCtl,
                      decoration: const InputDecoration(
                        labelText: 'Ghi chú',
                        prefixIcon: Icon(Icons.note_alt_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Hủy'),
        ),
        if (_employees.isNotEmpty)
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
            ),
            child: const Text('Lưu'),
          ),
      ],
    );
  }
}
