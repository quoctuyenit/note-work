import 'package:flutter/material.dart';
import 'package:note_work/database/app_database.dart';

class SlotItem extends StatefulWidget {
  final BookingSlot slot;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;

  const SlotItem({
    super.key,
    required this.slot,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<SlotItem> createState() => _SlotItemState();
}

class _SlotItemState extends State<SlotItem> {
  late final TextEditingController _ctl;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _ctl = TextEditingController(text: widget.slot.customerName ?? '');
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBooked = (widget.slot.customerName ?? '').isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isBooked ? Colors.orange.shade100 : Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Text(
            widget.slot.time,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _editing
                ? TextField(
                    controller: _ctl,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Tên khách (để trống = slot trống)',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (v) {
                      setState(() => _editing = false);
                      widget.onChanged(v);
                    },
                  )
                : GestureDetector(
                    onTap: () => setState(() => _editing = true),
                    child: Text(
                      isBooked ? (widget.slot.customerName ?? '') : 'Trống',
                      style: TextStyle(
                        fontStyle: isBooked ? FontStyle.normal : FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Xóa slot này',
            icon: const Icon(Icons.close),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }
}
