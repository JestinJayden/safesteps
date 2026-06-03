# Steply 🦺

**Veilig wandelen voor ouderen (60+) in Rotterdam — Flutter app + ESP32 armband**

Gebouwd door Team ThinkTank — Interdisciplinair Semester 6, Hogeschool Rotterdam.

---

## 📱 De 12 schermen

| Scherm | Bestand | Wat het doet |
|--------|---------|--------------|
| Splash | `splash_screen.dart` | Steply-logo, gaat na 2,5s naar Home |
| Home | `home_screen.dart` | Welkom Maria, keuze rustige wandeling / eigen bestemming + armband-status |
| Voorkeuren | `preferences_screen.dart` | "Wat vindt u prettig?" — vinkjes sturen routeberekening |
| Loading | `loading_screen.dart` | Logo + spinner, berekent ondertussen de echte route |
| Kaart bestemming | `map_destination_screen.dart` | Echte kaart, zoekbalk, aanbevolen route |
| Route overzicht | `route_overview_screen.dart` | "Uw wandeling" met afstand, tijd, rustpunten |
| Onderweg | `walk_screen.dart` | Voortgangsbalk, live kaart, armbandmelding |
| Waarschuwing | `warning_screen.dart` | "Het wordt drukker" — wijzig route of ga door |
| Hulp nodig | `help_screen.dart` | SOS: BEL 112 + situatie-opties |
| Situatie gekozen | `situation_chosen_screen.dart` | Bevestiging hulpverzoek voorbereiden |
| Hulp onderweg | `help_coming_screen.dart` | "Hulp is onderweg" + status |
| Profiel | `profile_screen.dart` | Mijn profiel, armband, contactpersonen |

---

## 🗂️ Mapstructuur

```
steply/
├── lib/
│   ├── main.dart                  ← Entry point, routing, Steply-thema
│   ├── config/
│   │   └── config.dart            ← OpenRouteService API-key
│   ├── screens/                   ← Alle 12 schermen (zie tabel)
│   ├── services/
│   │   ├── zone_service.dart      ← Rule-based zone-logica (Haversine)
│   │   ├── route_service.dart     ← Echte routes via OpenRouteService
│   │   ├── location_service.dart  ← GPS tracking
│   │   ├── ble_service.dart       ← Bluetooth ESP32-armband
│   │   └── storage_service.dart   ← SQLite + voorkeuren
│   ├── widgets/
│   │   ├── steply_logo.dart       ← Roze hart-logo met S
│   │   ├── gradient_scaffold.dart ← Blauwe gradient + witte kaarten
│   │   ├── bottom_nav.dart        ← Home / Route / Hulp / Profiel
│   │   └── rotterdam_map.dart     ← OpenStreetMap + zones + route
│   ├── models/
│   │   ├── zone.dart
│   │   └── walk_session.dart
│   └── data/
│       └── zones_rotterdam.json   ← 12 gesimuleerde zones
└── pubspec.yaml
```

---

## 🚀 Starten

```bash
flutter pub get
flutter run -d chrome      # of: flutter run (op emulator/telefoon)
```

Voor web (eerste keer):
```bash
flutter create --platforms=web .
flutter run -d chrome
```

---

## 🎨 Wat werkt er onder de motorkap

- **Echte kaart** van Rotterdam via OpenStreetMap met de 12 zones als gekleurde cirkels (groen/geel/rood)
- **GPS** volgt je live locatie (blauwe stip)
- **Routeberekening** van A naar B via OpenRouteService, houdt rekening met je voorkeuren
- **Voorkeuren** worden opgeslagen en vermijden drukke / donkere zones
- **Bluetooth** verbinding met de ESP32-armband (trilsignalen + noodknop)

---

## 👥 Team ThinkTank

Eden & Jizela (CMD) · Jahlani (INF) · Arrön (ADS&AI) · Mark (CE)
Hogeschool Rotterdam — Interdisciplinair Semester 6
