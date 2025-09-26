import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nail_schedule_app/ui/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo dữ liệu locale (ví dụ cho tiếng Việt)
  await initializeDateFormatting('vi_VN', null);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nail Schedule',
      theme: ThemeData(
        colorSchemeSeed: Colors.pink,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
