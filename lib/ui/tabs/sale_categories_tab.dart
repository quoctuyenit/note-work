import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_work/database/app_database.dart';
import 'package:note_work/providers/booking_provider.dart';

class SaleCategoriesTab extends ConsumerStatefulWidget {
  const SaleCategoriesTab({super.key});

  @override
  ConsumerState<SaleCategoriesTab> createState() => _SaleCategoriesTabState();
}

class _SaleCategoriesTabState extends ConsumerState<SaleCategoriesTab> {
  final TextEditingController _nameCtl = TextEditingController();

  @override
  void dispose() {
    _nameCtl.dispose();
    super.dispose();
  }

  Future<void> _addCategory() async {
    final name = _nameCtl.text.trim();
    if (name.isEmpty) return;
    final repo = ref.read(bookingRepoProvider);
    try {
      await repo.addSaleCategory(name);
      _nameCtl.clear();
      ref.refresh(saleCategoriesProvider);
    } catch (e) {
      final msg = (e is String)
          ? e
          : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  Future<void> _deleteCategory(SaleCategory cat) async {
    if (cat.isDefault || cat.name.toLowerCase() == 'nail') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể xóa loại doanh số mặc định (Nail).'),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc chắn muốn xóa loại "${cat.name}"?\nCác bản ghi doanh số thuộc loại này sẽ được tự động chuyển về loại mặc định "Nail".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final repo = ref.read(bookingRepoProvider);
    try {
      await repo.deleteSaleCategory(cat.id);
      ref.refresh(saleCategoriesProvider);
      ref.refresh(salesDaysProvider);
    } catch (e) {
      final msg = (e is String)
          ? e
          : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  Future<void> _editCategory(SaleCategory cat) async {
    final editCtl = TextEditingController(text: cat.name);
    final repo = ref.read(bookingRepoProvider);
    final updated = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sửa tên loại doanh số'),
        content: TextField(
          controller: editCtl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Tên loại doanh số'),
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
        await repo.updateSaleCategory(cat.id, editCtl.text.trim());
        ref.refresh(saleCategoriesProvider);
        ref.refresh(salesDaysProvider);
      } catch (e) {
        final msg = (e is String)
          ? e
          : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncCategories = ref.watch(saleCategoriesProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameCtl,
                  decoration: const InputDecoration(
                    labelText: 'Thêm loại doanh số mới',
                    hintText: 'VD: Nail, Gội đầu, Mi...',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onSubmitted: (_) => _addCategory(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _addCategory,
                icon: const Icon(Icons.add),
                label: const Text('Thêm'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: asyncCategories.when(
              data: (categories) {
                if (categories.isEmpty) {
                  return const Center(
                    child: Text('Chưa có loại doanh số nào'),
                  );
                }
                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (ctx, i) {
                    final cat = categories[i];
                    final isNailDefault =
                        cat.isDefault || cat.name.toLowerCase() == 'nail';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isNailDefault
                              ? Colors.pink.shade100
                              : Colors.purple.shade100,
                          foregroundColor: isNailDefault
                              ? Colors.pink.shade800
                              : Colors.purple.shade800,
                          child: Icon(
                            isNailDefault
                                ? Icons.spa_outlined
                                : Icons.category_outlined,
                            size: 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              cat.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            if (isNailDefault) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: Colors.pink.shade200),
                                ),
                                child: Text(
                                  'Mặc định',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueGrey, size: 20),
                              tooltip: 'Sửa tên',
                              onPressed: () => _editCategory(cat),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: isNailDefault
                                    ? Colors.grey.shade400
                                    : Colors.red,
                                size: 20,
                              ),
                              tooltip: isNailDefault
                                  ? 'Không thể xóa loại mặc định'
                                  : 'Xóa',
                              onPressed: isNailDefault
                                  ? null
                                  : () => _deleteCategory(cat),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Lỗi: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
