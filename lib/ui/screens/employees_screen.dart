import 'package:flutter/material.dart';
import 'package:note_work/repository/booking_repository.dart';
import 'package:note_work/database/app_database.dart';

class EmployeesScreen extends StatefulWidget {
  final BookingRepository bookingRepo;

  const EmployeesScreen({super.key, required this.bookingRepo});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  List<Employee> employees = [];
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployees() async {
    final data = await widget.bookingRepo.getEmployees();
    setState(() {
      employees = data;
    });
  }

  Future<void> _addEmployee() async {
    final name = nameController.text.trim();
    if (name.isEmpty) return;

    try {
      await widget.bookingRepo.addEmployee(name);
      nameController.clear();
      _loadEmployees();
    } catch (e) {
      final msg =
          (e is String) ? e : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  Future<void> _deleteEmployee(int id) async {
    await widget.bookingRepo.deleteEmployee(id);
    _loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cấu hình nhân viên')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên nhân viên',
                      prefixIcon: Icon(Icons.person_add_outlined),
                    ),
                    onSubmitted: (_) => _addEmployee(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addEmployee,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: employees.isEmpty
                  ? const Center(child: Text('Chưa có nhân viên nào'))
                  : ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final emp = employees[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              emp.name.trim().isNotEmpty
                                  ? emp.name.trim()[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                          title: Text(emp.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEmployee(emp.id),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
