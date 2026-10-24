import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalculatorSheet extends StatefulWidget {
  final double? initialValue;

  const CalculatorSheet({super.key, this.initialValue});

  /// Static helper to show Calculator as BottomSheet
  static Future<double?> show(BuildContext context, {double? initialValue}) {
    FocusScope.of(context).unfocus();
    return showModalBottomSheet<double>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) => CalculatorSheet(initialValue: initialValue),
    );
  }

  @override
  State<CalculatorSheet> createState() => _CalculatorSheetState();
}

class _CalculatorSheetState extends State<CalculatorSheet> {
  final NumberFormat _currencyFmt = NumberFormat('#,###', 'vi_VN');

  // Input expression (e.g. "500000 + 200000")
  String _expression = '';
  // Current evaluated result
  double _currentResult = 0;
  // Tracks if user has picked an operator and calculation is pending '='
  bool _hasPendingOperator = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue! > 0) {
      final initialInt = widget.initialValue!.round();
      _expression = initialInt.toString();
      _currentResult = widget.initialValue!;
    }
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'AC') {
        _expression = '';
        _currentResult = 0;
        _hasPendingOperator = false;
      } else if (key == 'del') {
        if (_expression.isNotEmpty) {
          _expression = _expression.trimRight();
          if (_expression.endsWith('+') ||
              _expression.endsWith('-') ||
              _expression.endsWith('×') ||
              _expression.endsWith('/') ||
              _expression.endsWith('÷')) {
            _expression = _expression.substring(0, _expression.length - 1).trimRight();
          } else {
            _expression = _expression.substring(0, _expression.length - 1);
          }
          _evaluate();
          // Kiểm tra xem biểu thức còn phép tính chưa hoàn tất không
          _hasPendingOperator = _expression.contains(RegExp(r'[\+\-×/÷]'));
        }
      } else if (key == '+' || key == '-' || key == '×' || key == 'x' || key == '/' || key == '÷') {
        final op = (key == 'x') ? '×' : (key == '÷') ? '/' : key;
        if (_expression.isEmpty) {
          if (_currentResult > 0) {
            _expression = '${_formatNum(_currentResult)} $op ';
            _hasPendingOperator = true;
          }
          return;
        }
        final trimmed = _expression.trimRight();
        final lastChar = trimmed.isEmpty ? '' : trimmed.substring(trimmed.length - 1);
        if (['+', '-', '×', '/', '÷'].contains(lastChar)) {
          // Thay thế toán tử nếu vừa nhập
          _expression = '${trimmed.substring(0, trimmed.length - 1)} $op ';
        } else {
          _expression = '$trimmed $op ';
        }
        _hasPendingOperator = true;
      } else if (key == '=') {
        _evaluate();
        if (_currentResult >= 0) {
          _expression = _formatNum(_currentResult);
        }
        _hasPendingOperator = false;
      } else if (key == 'OK') {
        _evaluate();
        Navigator.pop(context, _currentResult);
      } else if (key == '000') {
        final lastNum = _getLastNumberToken();
        if (lastNum.isNotEmpty && lastNum != '0') {
          _expression += '000';
          _evaluate();
        }
      } else {
        // Chữ số (0-9) hoặc dấu chấm (.)
        _expression += key;
        _evaluate();
      }
    });
  }

  String _getLastNumberToken() {
    final tokens = _expression.split(' ');
    return tokens.isNotEmpty ? tokens.last : '';
  }

  String _formatNum(double num) {
    if (num == num.roundToDouble()) {
      return num.toInt().toString();
    }
    return num.toString();
  }

  void _evaluate() {
    if (_expression.trim().isEmpty) {
      _currentResult = 0;
      return;
    }

    try {
      final tokens = _expression.trim().split(RegExp(r'\s+'));
      if (tokens.isEmpty) {
        _currentResult = 0;
        return;
      }

      double current = double.tryParse(tokens[0]) ?? 0;

      for (int i = 1; i < tokens.length; i += 2) {
        if (i + 1 >= tokens.length) break;
        final op = tokens[i];
        final nextToken = tokens[i + 1];
        final nextVal = double.tryParse(nextToken) ?? 0;

        if (op == '+') {
          current += nextVal;
        } else if (op == '-') {
          current -= nextVal;
        } else if (op == '×' || op == 'x' || op == '*') {
          current *= nextVal;
        } else if (op == '/' || op == '÷') {
          if (nextVal != 0) current /= nextVal;
        }
      }

      _currentResult = current < 0 ? 0 : current;
    } catch (_) {
      // Bỏ qua lỗi trong khi đang gõ dở biểu thức
    }
  }

  String _formatCurrency(double amount) {
    return '${_currencyFmt.format(amount.round())} đ';
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 20,
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Header title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calculate_outlined, color: Colors.pink),
                            SizedBox(width: 8),
                            Text(
                              'Bàn tính tiền',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          tooltip: 'Đóng',
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Màn hình hiển thị kết quả (co giãn an toàn không bị tràn pixel)
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 84),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.pink.shade100),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _expression.isEmpty ? '0' : _expression,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              _formatCurrency(_currentResult),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bàn phím máy tính 5 cột
                    _buildKeypad(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    const double buttonHeight = 50.0;
    const double spacing = 8.0;

    // 4 cột bên trái: 4 hàng
    final leftRows = [
      ['7', '8', '9', '/'],
      ['4', '5', '6', 'x'],
      ['1', '2', '3', '-'],
      ['0', '000', '.', '+'],
    ];

    // Nút ở cột 5 hàng 3&4 hiển thị "=" khi đang tính và "OK" khi chỉ nhập số hoặc đã tính xong
    final equalOrOkKey = _hasPendingOperator ? '=' : 'OK';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Khối 4 cột bên trái
        Expanded(
          flex: 4,
          child: Column(
            children: leftRows.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: spacing),
                child: Row(
                  children: row.map((key) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _buildKeyButton(key, height: buttonHeight),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ),

        // Cột thứ 5 bên phải
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              children: [
                // Hàng 1: AC
                _buildKeyButton('AC', height: buttonHeight),
                const SizedBox(height: spacing),

                // Hàng 2: del
                _buildKeyButton('del', height: buttonHeight),
                const SizedBox(height: spacing),

                // Hàng 3 & 4 gộp: nút = / OK (chiều cao 2 hàng)
                _buildKeyButton(
                  equalOrOkKey,
                  height: (buttonHeight * 2) + spacing,
                  isEqualOrOk: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyButton(
    String key, {
    required double height,
    bool isEqualOrOk = false,
  }) {
    final isOperator = ['/', 'x', '-', '+'].contains(key);
    final isAc = key == 'AC';
    final isDel = key == 'del';

    Color bgColor;
    Color fgColor;

    if (isEqualOrOk) {
      if (key == 'OK') {
        bgColor = Colors.pink;
        fgColor = Colors.white;
      } else {
        // Dấu "="
        bgColor = Colors.pink.shade600;
        fgColor = Colors.white;
      }
    } else if (isOperator) {
      bgColor = Colors.pink.shade50;
      fgColor = Colors.pink.shade700;
    } else if (isAc) {
      bgColor = Colors.red.shade50;
      fgColor = Colors.red.shade700;
    } else if (isDel) {
      bgColor = Colors.grey.shade200;
      fgColor = Colors.black87;
    } else {
      bgColor = Colors.white;
      fgColor = Colors.black87;
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isEqualOrOk || isOperator || isAc)
              ? Colors.transparent
              : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _onKeyPress(key),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  key,
                  style: TextStyle(
                    fontSize: key == '000'
                        ? 16
                        : (key == '=' || key == 'OK')
                            ? 22
                            : 20,
                    fontWeight: (isOperator || isAc || isDel || isEqualOrOk)
                        ? FontWeight.bold
                        : FontWeight.w600,
                    color: fgColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
