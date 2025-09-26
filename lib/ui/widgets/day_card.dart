import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nail_schedule_app/database/app_database.dart';
import 'package:nail_schedule_app/repository/booking_repository.dart';
import 'package:nail_schedule_app/ui/screens/add_slot_dialog.dart';

class DayCard extends StatefulWidget {
  final BookingRepository repo;
  final BookingDay day;
  final List<BookingSlot> slots;
  final bool readOnly; // nếu true thì không cho edit slot/day
  final bool startCollapsed;
  final VoidCallback? onChanged;

  const DayCard({
    super.key,
    required this.repo,
    required this.day,
    required this.slots,
    this.readOnly = false,
    this.startCollapsed = false,
    this.onChanged,
  });

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  late bool collapsed;

  @override
  void initState() {
    super.initState();
    collapsed = widget.startCollapsed ? true : widget.day.isCollapsed;
  }

  String _weekdayShort(int w) {
    // Monday=1 -> T2, ... Sunday=7 -> CN
    if (w == DateTime.sunday) return 'CN';
    return 'T${w + 1 - 1}'; // simpler: Mon(1)->T2 etc
    // but above is wrong: adjust:
    // we'll map explicitly
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
    await widget.repo.toggleCollapse(widget.day.id);
    setState(() => collapsed = !collapsed);
    widget.onChanged?.call();
  }

  Future<void> _editDayDate() async {
    if (widget.readOnly) return;
    final now = DateTime.now();
    final booked = await widget.repo.getAllBookingDays(); // get set outside if large
    final exclude = widget.day.id;
    final bookedSet = <DateTime>{};
    for (final d in booked) if (d.id != exclude) bookedSet.add(DateTime(d.date.year, d.date.month, d.date.day));

    final picked = await showDatePicker(
      context: context,
      initialDate: widget.day.date,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
      selectableDayPredicate: (dt) {
        final dd = DateTime(dt.year, dt.month, dt.day);
        if (dd.isBefore(DateTime(now.year, now.month, now.day))) return false;
        return !bookedSet.contains(dd);
      },
    );
    if (picked == null) return;
    try {
      await widget.repo.updateDayDate(widget.day.id, picked);
      widget.onChanged?.call();
    } catch (e) {
      final msg = (e is String) ? e : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _addSlot() async {
    if (widget.readOnly) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AddOrEditSlotDialog(repo: widget.repo, dayId: widget.day.id),
    );
    if (ok == true) widget.onChanged?.call();
  }

  Future<void> _editSlot(BookingSlot s) async {
    if (widget.readOnly) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AddOrEditSlotDialog(
        repo: widget.repo,
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
    if (widget.readOnly) return;
    try {
      await widget.repo.removeSlot(s.id);
      widget.onChanged?.call();
    } catch (e) {
      final msg = (e is String) ? e : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.day;
    final isToday = DateTime.now().year == day.date.year &&
        DateTime.now().month == day.date.month &&
        DateTime.now().day == day.date.day;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(_dateTitle(day.date), style: TextStyle(fontWeight: isToday ? FontWeight.bold : FontWeight.w600, fontSize: 16, color: isToday ? Colors.pink : null))),
                IconButton(icon: Icon(collapsed ? Icons.unfold_more : Icons.unfold_less), onPressed: _toggleCollapse),
                if (!widget.readOnly) IconButton(icon: const Icon(Icons.edit_calendar), onPressed: _editDayDate),
                if (!widget.readOnly)
                  IconButton(
                    icon: Icon(day.isCompleted ? Icons.undo : Icons.check_circle_outline),
                    onPressed: () async {
                      try {
                        await widget.repo.setDayCompleted(day.id, !day.isCompleted);
                        widget.onChanged?.call();
                      } catch (e) {
                        final msg = (e is String) ? e : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                      }
                    },
                  ),
              ],
            ),
            if (!collapsed) ...[
              const Divider(),
              if (widget.slots.isEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text('Chưa có khung giờ')) else
                ...widget.slots.map((s) {
                  return ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(s.time),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.customerName?.trim().isNotEmpty == true ? s.customerName! : 'Trống'),
                      if (s.note != null && s.note!.trim().isNotEmpty) Text('Ghi chú: ${s.note}', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
                    ]),
                    trailing: widget.readOnly
                        ? null
                        : Wrap(children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _editSlot(s)),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteSlot(s)),
                          ]),
                  );
                }),
              if (!widget.readOnly)
                Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: _addSlot, icon: const Icon(Icons.add), label: const Text('Thêm khung giờ'))),
            ],
          ],
        ),
      ),
    );
  }
}
