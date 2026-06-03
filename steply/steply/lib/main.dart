import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/preferences_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/map_screen.dart';
import 'screens/route_overview_screen.dart';
import 'screens/walk_screen.dart';
import 'screens/warning_screen.dart';
import 'screens/help_screen.dart';
import 'screens/situation_screen.dart';
import 'screens/help_coming_screen.dart';
import 'screens/profile_screen.dart';

import 'services/location_service.dart';
import 'services/ble_service.dart';
import 'services/zone_service.dart';
import 'services/route_service.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SteplyApp());
}

class SteplyApp extends StatelessWidget {
  const SteplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => BleService()),
        ChangeNotifierProvider(create: (_) => ZoneService()),
        ChangeNotifierProvider(create: (_) => RouteService()),
        ChangeNotifierProvider(create: (_) => StorageService()),
      ],
      child: MaterialApp(
        title: 'Steply',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: '/',
        routes: {
          '/':              (_) => const SplashScreen(),
          '/welcome':       (_) => const WelcomeScreen(),
          '/home':          (_) => const HomeScreen(),
          '/preferences':   (_) => const PreferencesScreen(),
          '/loading':       (_) => const LoadingScreen(),
          '/map':           (_) => const MapScreen(),
          '/route-overview':(_) => const RouteOverviewScreen(),
          '/walk':          (_) => const WalkScreen(),
          '/warning':       (_) => const WarningScreen(),
          '/help':          (_) => const HelpScreen(),
          '/situation':     (_) => const SituationScreen(),
          '/help-coming':   (_) => const HelpComingScreen(),
          '/profile':       (_) => const ProfileScreen(),
        },
      ),
    );
  }
}

// ─── Steply kleurenschema ──────────────────────────────────────────────────
class AppTheme {
  static const navy        = Color(0xFF1B3A63);
  static const navyDark    = Color(0xFF15294A);
  static const pink        = Color(0xFFE6147A);
  static const green       = Color(0xFF1D9E75);
  static const greenLight  = Color(0xFFE1F5EE);
  static const amber       = Color(0xFFEF9F27);
  static const amberLight  = Color(0xFFFAEEDA);
  static const red         = Color(0xFFE23B3B);
  static const redLight    = Color(0xFFFCEBEB);
  static const cardGrey    = Color(0xFFF4F6F9);

  // Gradient achtergrond (donkerblauw boven -> lichtblauw onder)
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF24426E), Color(0xFF6E9BC4), Color(0xFFB6D2E8)],
    stops: [0.0, 0.55, 1.0],
  );

  static final light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(seedColor: navy, primary: navy, secondary: green),
    scaffoldBackgroundColor: Colors.transparent,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
