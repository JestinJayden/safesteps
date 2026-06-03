# Steply

**Veilig wandelen door Rotterdam voor ouderen (60+)** — Flutter app + ESP32 armband.
Team ThinkTank · Interdisciplinair Semester 6 · Hogeschool Rotterdam.

## Schermen
- Splash, Home ("Welkom terug, Maria"), Voorkeuren instellen, Loading
- Kaart (kies bestemming), Route overzicht, Onderweg
- Armband waarschuwing, Hulp (SOS), Situatie gekozen, Hulp onderweg, Profiel

## Installeren
```bash
flutter pub get
flutter run -d chrome      # of een Android emulator
```

## Mappen
- `lib/screens/` — alle schermen
- `lib/services/` — GPS, Bluetooth, zones, routes, opslag
- `lib/widgets/` — logo, gradient achtergrond, bottom nav, kaart
- `lib/data/zones_rotterdam.json` — gesimuleerde dataset (12 zones)
- `lib/config/config.dart` — OpenRouteService API key

## Navigatie
Bottom nav: Home · Route · Hulp · Profiel
