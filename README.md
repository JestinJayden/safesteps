# SafeSteps 🦺

**Veilig wandelen door Rotterdam — Flutter app + ESP32 armband**

Gebouwd voor Interdisciplinair Semester 6, Hogeschool Rotterdam (Team ThinkTank).

---

## 📱 Wat doet de app?

- Toont een kaart van Rotterdam met kleurzones (groen / geel / rood)
- Stelt automatisch de veiligste wandelroute voor
- Koppelt via Bluetooth met een ESP32-armband
- Geeft trilsignaal als je een drukke zone inloopt
- Houdt tijd, afstand en wandelhistorie bij
- Noodknop op de armband belt je contactpersoon of 112

---

## 🗂️ Mapstructuur

```
safesteps/
├── lib/
│   ├── main.dart                  ← App entry point + routing + thema
│   ├── screens/
│   │   ├── onboard_screen.dart    ← Welkomscherm
│   │   ├── home_screen.dart       ← Kaart + route selectie
│   │   ├── walk_screen.dart       ← Live wandelen (timer, GPS, BLE)
│   │   ├── walk_done_screen.dart  ← Samenvatting na wandeling
│   │   ├── notifications_screen.dart
│   │   ├── chat_screen.dart
│   │   └── settings_screen.dart
│   ├── services/
│   │   ├── zone_service.dart      ← Rule-based zone logica (Haversine)
│   │   ├── ble_service.dart       ← Bluetooth ESP32 verbinding
│   │   ├── location_service.dart  ← GPS tracking
│   │   └── storage_service.dart   ← SQLite + SharedPreferences
│   ├── models/
│   │   ├── zone.dart              ← Zone model + ZoneLevel enum
│   │   └── walk_session.dart      ← Wandelsessie model
│   ├── widgets/
│   │   ├── bottom_nav.dart        ← Gedeelde navigatiebalk
│   │   └── zone_badge.dart        ← Groen/geel/rood badge
│   └── data/
│       └── zones_rotterdam.json   ← Gesimuleerde dataset (12 zones)
└── pubspec.yaml
```

---

## 🚀 Installeren en starten

### Vereisten
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x of hoger)
- Android Studio of VS Code met Flutter plugin
- Android emulator of fysiek Android apparaat

### Stappen

```bash
# 1. Clone de repo
git clone https://github.com/jouw-naam/safesteps.git
cd safesteps

# 2. Dependencies installeren
flutter pub get

# 3. App starten (emulator of apparaat)
flutter run
```

### Bouwen voor Android

```bash
flutter build apk --release
# APK staat in: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔵 Bluetooth / ESP32 koppeling

De app zoekt naar een BLE-apparaat met naam `SafeSteps`. De UUIDs staan in `lib/services/ble_service.dart`:

```
Service UUID:    12345678-1234-1234-1234-123456789abc
Vibrate Char:    12345678-1234-1234-1234-123456789abd
Button Char:     12345678-1234-1234-1234-123456789abe
```

**Trilcommando's (write naar Vibrate Characteristic):**
| Byte  | Betekenis              |
|-------|------------------------|
| 0x01  | Kort triltje (zone)    |
| 0x02  | Lang triltje (nood)    |
| 0x03  | Zacht patroon (thuis)  |

**Knopcommando's (notify van Button Characteristic):**
| Byte  | Betekenis              |
|-------|------------------------|
| 0x01  | 1x drukken → contact   |
| 0x02  | 2x drukken → 112       |

> De ESP32 Arduino/PlatformIO firmware volgt apart.

---

## 🗺️ Zone dataset

De gesimuleerde dataset staat in `lib/data/zones_rotterdam.json`. Elke zone heeft:

| Veld            | Type    | Omschrijving                          |
|-----------------|---------|---------------------------------------|
| `id`            | string  | Unieke ID                             |
| `name`          | string  | Naam van het gebied                   |
| `lat` / `lng`   | double  | GPS coördinaten middelpunt            |
| `radius_m`      | number  | Straal van de zone in meters          |
| `comfort_score` | number  | 1–10 (10 = meest comfortabel)         |
| `good_lighting` | bool    | Of het gebied goed verlicht is        |
| `busy`          | bool    | Of het een druk gebied is             |

**Regels (zone_service.dart):**
- Score ≥ 7 → 🟢 Comfortabel
- Score 4–7 → 🟡 Let op
- Score < 4  → 🔴 Drukker gebied
- Avondmodus: score daalt met 1.5, slecht verlicht = direct rood

---

## 📦 Gebruikte packages

| Package              | Waarvoor                        |
|----------------------|---------------------------------|
| `flutter_map`        | Kaartweergave (OpenStreetMap)   |
| `flutter_blue_plus`  | Bluetooth ESP32 verbinding      |
| `geolocator`         | GPS locatie                     |
| `provider`           | State management                |
| `sqflite`            | Lokale database (wandelhistorie)|
| `shared_preferences` | Gebruikersvoorkeuren opslaan    |
| `permission_handler` | GPS + BT permissies             |

---

## 👥 Team ThinkTank

Arrön · Eden · Jizela · Jahlani · Mark  
Hogeschool Rotterdam — CMI Interdisciplinair Semester 6 (2025–2026)
