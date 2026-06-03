import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/preferences_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/map_destination_screen.dart';
import 'screens/route_overview_screen.dart';
import 'screens/walk_screen.dart';
import 'screens/warning_screen.dart';
import 'screens/help_screen.dart';
import 'screens/situation_chosen_screen.dart';
import 'screens/help_coming_screen.dart';
import 'screens/profile_screen.dart';

import 'services/location_service.dart';
import 'services/ble_service.dart';
import 'services/zone_service.dart';
import 'services/route_service.dart';
import 'services/storage_service.dart';

void main() async {
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
          '/':                  (_) => const SplashScreen(),
          '/home':              (_) => const HomeScreen(),
          '/preferences':       (_) => const PreferencesScreen(),
          '/loading':           (_) => const LoadingScreen(),
          '/map-destination':   (_) => const MapDestinationScreen(),
          '/route-overview':    (_) => const RouteOverviewScreen(),
          '/walk':              (_) => const WalkScreen(),
          '/warning':           (_) => const WarningScreen(),
          '/help':              (_) => const HelpScreen(),
          '/situation-chosen':  (_) => const SituationChosenScreen(),
          '/help-coming':       (_) => const HelpComingScreen(),
          '/profile':           (_) => const ProfileScreen(),
        },
      ),
    );
  }
}

// ─── Steply kleurenschema (gebaseerd op de UI-designs) ────────────────────────
class AppTheme {
  static const navy        = Color(0xFF1B2A4A);  // donkerblauwe knoppen/tekst
  static const navyDark    = Color(0xFF152138);
  static const pink        = Color(0xFFE8156C);  // roze accent (logo hart)
  static const pinkDark    = Color(0xFFC30E58);

  static const green       = Color(0xFF2BA86A);
  static const greenLight  = Color(0xFFDFF5EA);
  static const amber       = Color(0xFFEFA23B);
  static const amberLight  = Color(0xFFFAEEDA);
  static const red         = Color(0xFFE23B3B);
  static const redLight    = Color(0xFFFCEBEB);

  // Gradient achtergrond (donkerblauw bovenaan → lichtblauw onderaan)
  static const bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2D4979), Color(0xFF5E8BBF), Color(0xFFBcd3e8)],
    stops: [0.0, 0.55, 1.0],
  );

  static final light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(seedColor: navy, primary: navy, secondary: pink),
    scaffoldBackgroundColor: Colors.transparent,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
