import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nail_schedule_app/repository/booking_repository.dart';
import 'package:nail_schedule_app/database/app_database.dart';

class SearchCustomerDelegate extends SearchDelegate<void> {
  final BookingRepository repo;
  SearchCustomerDelegate(this.repo);

  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _buildResultList();
  @override
  Widget buildSuggestions(BuildContext context) => _buildResultList();

  Widget _buildResultList() {
    if (query.trim().isEmpty) return const Center(child: Text('Nhập tên khách để tìm'));
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: repo.searchByCustomer(query),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
        final list = snap.data ?? [];
        if (list.isEmpty) return const Center(child: Text('Không tìm thấy'));
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (c, i) {
            final item = list[i];
            final BookingSlot slot = item['slot'] as BookingSlot;
            final BookingDay day = item['day'] as BookingDay;
            final dateStr = DateFormat('dd/MM/yyyy').format(day.date);
            return ListTile(
              title: Text(slot.customerName ?? 'Trống'),
              subtitle: Text('$dateStr - ${slot.time}'),
              onTap: () {},
            );
          },
        );
      },
    );
  }
}
