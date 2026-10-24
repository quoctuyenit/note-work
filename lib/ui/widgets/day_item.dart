import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_work/database/app_database.dart';
import 'package:note_work/ui/screens/add_slot_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_work/providers/booking_provider.dart';

class DayItem extends ConsumerStatefulWidget {
  final BookingDay day;
  final List<BookingSlot> slots;
  final bool isCompleteTab;
  final VoidCallback? onChanged;

  const DayItem({
    super.key,
    required this.day,
    required this.slots,
    required this.isCompleteTab,
    this.onChanged,
  });

  @override
  ConsumerState<DayItem> createState() => _DayItemState();
}

class _DayItemState extends ConsumerState<DayItem> {
  late bool collapsed;

  @override
  void initState() {
    super.initState();
    // auto collapsed on load
    collapsed = true;
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

  Future<void> _toggleCollapse() async {
    final repo = ref.read(bookingRepoProvider);
    await repo.toggleCollapse(widget.day.id);
    setState(() => collapsed = !collapsed);
    widget.onChanged?.call();
  }

  Future<void> _editDate() async {
    if (widget.isCompleteTab) return;
    final repo = ref.read(bookingRepoProvider);
    final now = DateTime.now();
    final booked = await repo.getBookedDateSet(excludeDayId: widget.day.id);

    final picked = await showDatePicker(
      context: context,
      initialDate: widget.day.date,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
      selectableDayPredicate: (dt) {
        final dd = DateTime(dt.year, dt.month, dt.day);
        if (dd.isBefore(DateTime(now.year, now.month, now.day))) return false;
        return !booked.contains(dd);
      },
    );
    if (picked == null) return;
    try {
      await repo.updateDayDate(widget.day.id, picked);
      widget.onChanged?.call();
    } catch (e) {
      final msg = (e is String) ? e : e.toString();
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _addSlot() async {
    final repo = ref.read(bookingRepoProvider);
    final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AddOrEditSlotDialog(repo: repo, dayId: widget.day.id));
    if (ok == true) widget.onChanged?.call();
  }

  Future<void> _editSlot(BookingSlot s) async {
    final repo = ref.read(bookingRepoProvider);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AddOrEditSlotDialog(
        repo: repo,
        dayId: s.dayId,
        slotId: s.id,
        initialTime: s.time,
        initialName: s.customerName,
        initialNote: s.note,
      ),
    );
    if (ok == true) widget.onChanged?.call();
  }

  Future<void> _deleteSlot(BookingSlot s) async {
    if (widget.isCompleteTab) return;
    final repo = ref.read(bookingRepoProvider);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn muốn xoá khung giờ này?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Xoá')),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await repo.removeSlot(s.id);
        widget.onChanged?.call();
      } catch (e) {
        final msg = (e is String) ? e : e.toString();
        if (mounted)
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  Future<void> _toggleComplete() async {
    if (widget.isCompleteTab) return;
    final repo = ref.read(bookingRepoProvider);
    try {
      await repo.setDayCompleted(widget.day.id, true);
      widget.onChanged?.call();
    } catch (e) {
      final msg = (e is String) ? e : e.toString();
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.day;
    final slots = widget.slots;
    final today = DateTime.now();
    final dayOnly = DateTime(day.date.year, day.date.month, day.date.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    final canRevert = !dayOnly.isBefore(todayOnly);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(children: [
          Row(children: [
            Expanded(
                child: Text(_dateTitle(day.date),
                    style: TextStyle(
                        fontWeight: dayOnly == todayOnly
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 16,
                        color: dayOnly == todayOnly ? Colors.pink : null))),
            IconButton(
                tooltip: collapsed ? 'Mở rộng' : 'Thu gọn',
                icon: Icon(collapsed ? Icons.unfold_more : Icons.unfold_less),
                onPressed: _toggleCollapse),
            if (!widget.isCompleteTab)
              IconButton(
                  icon: const Icon(Icons.edit_calendar), onPressed: _editDate),
            IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Thêm khung giờ',
                onPressed: _addSlot),
            if (!widget.isCompleteTab)
              IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  tooltip: 'Hoàn tất ngày',
                  onPressed: _toggleComplete),
            if (widget.isCompleteTab && canRevert)
              IconButton(
                icon: const Icon(Icons.undo),
                tooltip: 'Chuyển lại đang xử lý',
                onPressed: () async {
                  final repo = ref.read(bookingRepoProvider);
                  try {
                    await repo.setDayCompleted(day.id, false);
                    widget.onChanged?.call();
                  } catch (e) {
                    final msg = (e is String) ? e : e.toString();
                    if (mounted)
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(msg)));
                  }
                },
              ),
          ]),
          if (!collapsed) ...[
            const Divider(),
            if (slots.isEmpty)
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Chưa có khung giờ'))
            else
              ...slots.map((s) {
                return ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(s.time),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.customerName?.trim().isNotEmpty == true
                            ? s.customerName!
                            : 'Trống'),
                        if (s.note != null && s.note!.trim().isNotEmpty)
                          Text('Ghi chú: ${s.note}',
                              style: const TextStyle(
                                  fontSize: 12, fontStyle: FontStyle.italic)),
                      ]),
                  trailing: widget.isCompleteTab
                      ? Wrap(spacing: 4, children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editSlot(s)),
                        ])
                      : Wrap(spacing: 4, children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editSlot(s)),
                          IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSlot(s)),
                        ]),
                );
              }).toList(),
          ],
        ]),
      ),
    );
  }
}
