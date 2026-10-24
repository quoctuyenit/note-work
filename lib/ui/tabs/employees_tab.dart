import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_work/database/app_database.dart';
import 'package:note_work/providers/booking_provider.dart';

class EmployeesTab extends ConsumerStatefulWidget {
  const EmployeesTab({super.key});

  @override
  ConsumerState<EmployeesTab> createState() => _EmployeesTabState();
}

class _EmployeesTabState extends ConsumerState<EmployeesTab> {
  final TextEditingController _nameCtl = TextEditingController();

  @override
  void dispose() {
    _nameCtl.dispose();
    super.dispose();
  }

  Future<void> _addEmployee() async {
    final name = _nameCtl.text.trim();
    if (name.isEmpty) return;
    final repo = ref.read(bookingRepoProvider);
    try {
      await repo.addEmployee(name);
      _nameCtl.clear();
      ref.refresh(employeesProvider);
    } catch (e) {
      final msg = (e is String)
          ? e
          : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  Future<void> _deleteEmployee(int id) async {
    final repo = ref.read(bookingRepoProvider);
    await repo.deleteEmployee(id);
    ref.refresh(employeesProvider);
  }

  Future<void> _editEmployee(Employee emp) async {
    final editCtl = TextEditingController(text: emp.name);
    final repo = ref.read(bookingRepoProvider);
    final updated = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sửa tên nhân viên'),
        content: TextField(
          controller: editCtl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Tên nhân viên'),
          onSubmitted: (val) {
            if (val.trim().isNotEmpty) {
              Navigator.pop(ctx, true);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (editCtl.text.trim().isNotEmpty) {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (updated == true) {
      try {
        await repo.updateEmployee(emp.id, editCtl.text.trim());
        ref.refresh(employeesProvider);
      } catch (e) {
        final msg = (e is String)
            ? e
            : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncEmployees = ref.watch(employeesProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Nhập tên nhân viên
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameCtl,
                  decoration: const InputDecoration(
                    labelText: 'Thêm nhân viên (ví dụ: Nguyễn Văn A)',
                    prefixIcon: Icon(Icons.person_add_outlined),
                  ),
                  onSubmitted: (_) => _addEmployee(),
                ),
              ),
              IconButton(
                tooltip: 'Thêm',
                icon: const Icon(Icons.add),
                onPressed: _addEmployee,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Danh sách nhân viên
          Expanded(
            child: asyncEmployees.when(
              data: (list) {
                if (list.isEmpty) {
                  return const Center(child: Text('Chưa có nhân viên nào'));
                }
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final emp = list[i];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          emp.name.trim().isNotEmpty
                              ? emp.name.trim()[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(
                        emp.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Sửa',
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () => _editEmployee(emp),
                          ),
                          IconButton(
                            tooltip: 'Xóa',
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () => _deleteEmployee(emp.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Lỗi: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
