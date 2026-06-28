import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kuttiomp_mobile/screens/home_screen.dart';
import 'package:kuttiomp_mobile/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env optional in development
  }
  runApp(const KuttiompApp());
}

class KuttiompApp extends StatelessWidget {
  const KuttiompApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D5A3D),
          surface: const Color(0xFFF5F3EF),
        ),
        fontFamily: 'Georgia',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}