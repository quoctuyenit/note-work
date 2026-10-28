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
  List<SaleCategory> _categories = [];
  bool _loadingData = true;

  Employee? _selectedEmployee;
  SaleCategory? _selectedCategory;
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
    final empList = await widget.repo.getEmployees();
    final catList = await widget.repo.getSaleCategories();

    setState(() {
      _employees = empList;
      _categories = catList;
      _loadingData = false;

      if (widget.existingSale != null) {
        final s = widget.existingSale!;
        _amount = s.amount;
        _amountCtl.text = _formatCurrency(s.amount);
        _noteCtl.text = s.note ?? '';

        try {
          _selectedEmployee = empList.firstWhere((e) => e.id == s.employeeId);
        } catch (_) {
          if (empList.isNotEmpty) _selectedEmployee = empList.first;
        }

        // Chọn category khớp với bản ghi hiện tại
        SaleCategory? matchCat;
        if (s.categoryId != null) {
          try {
            matchCat = catList.firstWhere((c) => c.id == s.categoryId);
          } catch (_) {}
        }
        if (matchCat == null && s.category.isNotEmpty) {
          try {
            matchCat = catList.firstWhere(
                (c) => c.name.toLowerCase() == s.category.toLowerCase());
          } catch (_) {}
        }
        _selectedCategory =
            matchCat ?? (catList.isNotEmpty ? catList.first : null);
      } else {
        if (empList.isNotEmpty) {
          _selectedEmployee = empList.first;
        }
        // Thêm mới: Mặc định chọn "Nail"
        try {
          _selectedCategory = catList.firstWhere(
              (c) => c.name.toLowerCase() == 'nail' || c.isDefault);
        } catch (_) {
          _selectedCategory = catList.isNotEmpty ? catList.first : null;
        }
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
    final categoryName = _selectedCategory?.name ?? 'Nail';
    final categoryId = _selectedCategory?.id;

    try {
      if (widget.existingSale == null) {
        // Add new
        await widget.repo.addSaleToDay(
          widget.dayId,
          employeeId: _selectedEmployee!.id,
          employeeName: _selectedEmployee!.name,
          amount: _amount,
          note: note.isEmpty ? null : note,
          category: categoryName,
          categoryId: categoryId,
        );
      } else {
        // Update
        await widget.repo.updateSale(
          widget.existingSale!.id,
          employeeId: _selectedEmployee!.id,
          employeeName: _selectedEmployee!.name,
          amount: _amount,
          note: note.isEmpty ? null : note,
          category: categoryName,
          categoryId: categoryId,
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
      content: _loadingData
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

                    // Chọn Loại doanh số
                    Row(
                      children: const [
                        Icon(Icons.spa_outlined, size: 18, color: Colors.pink),
                        SizedBox(width: 6),
                        Text(
                          'Loại doanh số',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (_categories.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Mặc định: Nail',
                            style: TextStyle(fontSize: 13)),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: _categories.map((cat) {
                          final isSelected = _selectedCategory?.id == cat.id ||
                              (_selectedCategory == null &&
                                  (cat.isDefault ||
                                      cat.name.toLowerCase() == 'nail'));
                          return ChoiceChip(
                            label: Text(
                              cat.name,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.pink.shade800
                                    : Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: Colors.pink.shade50,
                            backgroundColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.pink
                                    : Colors.grey.shade300,
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedCategory = cat);
                              }
                            },
                          );
                        }).toList(),
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
