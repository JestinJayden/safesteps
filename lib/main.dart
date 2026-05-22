import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/onboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/walk_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/walk_done_screen.dart';
import 'services/location_service.dart';
import 'services/ble_service.dart';
import 'services/zone_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SafeStepsApp());
}

class SafeStepsApp extends StatelessWidget {
  const SafeStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => BleService()),
        ChangeNotifierProvider(create: (_) => ZoneService()),
        ChangeNotifierProvider(create: (_) => StorageService()),
      ],
      child: MaterialApp(
        title: 'SafeSteps',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: '/',
        routes: {
          '/':           (_) => const OnboardScreen(),
          '/home':       (_) => const HomeScreen(),
          '/walk':       (_) => const WalkScreen(),
          '/walk-done':  (_) => const WalkDoneScreen(),
          '/notifs':     (_) => const NotificationsScreen(),
          '/chat':       (_) => const ChatScreen(),
          '/settings':   (_) => const SettingsScreen(),
        },
      ),
    );
  }
}

// ─── Kleurenschema (donkerblauw + groen, gebaseerd op Steply-design) ──────────
class AppTheme {
  static const navy  = Color(0xFF1A2744);
  static const green = Color(0xFF1D9E75);
  static const greenLight = Color(0xFFE1F5EE);
  static const amber = Color(0xFFEF9F27);
  static const amberLight = Color(0xFFFAEEDA);
  static const red   = Color(0xFFE24B4A);
  static const redLight = Color(0xFFFCEBEB);

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: navy,
      primary: navy,
      secondary: green,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: navy,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
      ),
    ),
  );
}
