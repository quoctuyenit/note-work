import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IosMonthYearResult {
  final int year;
  final int? month; // null nếu chọn cả năm

  const IosMonthYearResult({
    required this.year,
    this.month,
  });
}

Future<IosMonthYearResult?> showIosMonthYearPicker({
  required BuildContext context,
  required int initialYear,
  int? initialMonth,
  bool allowYearOnly = true,
}) {
  return showModalBottomSheet<IosMonthYearResult>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _IosMonthYearPickerSheet(
      initialYear: initialYear,
      initialMonth: initialMonth ?? DateTime.now().month,
      allowYearOnly: allowYearOnly,
      isYearOnly: initialMonth == null,
    ),
  );
}

class _IosMonthYearPickerSheet extends StatefulWidget {
  final int initialYear;
  final int initialMonth;
  final bool allowYearOnly;
  final bool isYearOnly;

  const _IosMonthYearPickerSheet({
    required this.initialYear,
    required this.initialMonth,
    required this.allowYearOnly,
    required this.isYearOnly,
  });

  @override
  State<_IosMonthYearPickerSheet> createState() =>
      _IosMonthYearPickerSheetState();
}

class _IosMonthYearPickerSheetState extends State<_IosMonthYearPickerSheet> {
  static const int minYear = 2020;
  late final int maxYear = DateTime.now().year + 1;

  late bool _isYearOnly;
  late int _selectedMonth;
  late int _selectedYear;

  late final FixedExtentScrollController _monthController;
  late final FixedExtentScrollController _yearController;

  late final List<int> _years = [
    for (int y = minYear; y <= maxYear; y++) y,
  ];

  @override
  void initState() {
    super.initState();
    _isYearOnly = widget.isYearOnly;
    _selectedMonth = widget.initialMonth.clamp(1, 12);
    _selectedYear = widget.initialYear.clamp(minYear, maxYear);

    _monthController =
        FixedExtentScrollController(initialItem: _selectedMonth - 1);
    final yearIdx = _years.indexOf(_selectedYear);
    _yearController = FixedExtentScrollController(
        initialItem: yearIdx >= 0 ? yearIdx : 0);
  }

  @override
  void dispose() {
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thanh Handle bar
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),

            // Thanh tiêu đề & nút Huỷ / Xong
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Hủy',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const Text(
                    'Chọn thời gian',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(
                        context,
                        IosMonthYearResult(
                          year: _selectedYear,
                          month: _isYearOnly ? null : _selectedMonth,
                        ),
                      );
                    },
                    child: const Text(
                      'Xong',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (widget.allowYearOnly) ...[
              const SizedBox(height: 8),
              // Segmented switch: Theo Tháng / Cả Năm
              CupertinoSlidingSegmentedControl<bool>(
                groupValue: _isYearOnly,
                children: const {
                  false: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text('Theo Tháng', style: TextStyle(fontSize: 14)),
                  ),
                  true: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text('Cả Năm', style: TextStyle(fontSize: 14)),
                  ),
                },
                onValueChanged: (val) {
                  if (val != null) {
                    setState(() => _isYearOnly = val);
                  }
                },
              ),
            ],

            const Divider(height: 24),

            // Khối 2 bánh xe cuộn iOS (CupertinoPicker)
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  // Cột 1: Tháng (nếu không chọn xem cả năm)
                  if (!_isYearOnly)
                    Expanded(
                      flex: 1,
                      child: CupertinoPicker.builder(
                        scrollController: _monthController,
                        itemExtent: 40,
                        useMagnifier: true,
                        magnification: 1.2,
                        selectionOverlay:
                            const CupertinoPickerDefaultSelectionOverlay(
                          background: Color(0x15E91E63),
                        ),
                        onSelectedItemChanged: (idx) {
                          setState(() {
                            _selectedMonth = idx + 1;
                          });
                        },
                        childCount: 12,
                        itemBuilder: (ctx, idx) {
                          final m = idx + 1;
                          final isSelected = m == _selectedMonth;
                          return Center(
                            child: Text(
                              'Tháng $m',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? Colors.pink : Colors.black87,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Cột 2: Năm
                  Expanded(
                    flex: 1,
                    child: CupertinoPicker.builder(
                      scrollController: _yearController,
                      itemExtent: 40,
                      useMagnifier: true,
                      magnification: 1.2,
                      selectionOverlay:
                          const CupertinoPickerDefaultSelectionOverlay(
                        background: Color(0x15E91E63),
                      ),
                      onSelectedItemChanged: (idx) {
                        setState(() {
                          _selectedYear = _years[idx];
                        });
                      },
                      childCount: _years.length,
                      itemBuilder: (ctx, idx) {
                        final y = _years[idx];
                        final isSelected = y == _selectedYear;
                        return Center(
                          child: Text(
                            'Năm $y',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.pink : Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
