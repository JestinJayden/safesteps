// ─── services/ble_service.dart ────────────────────────────────────────────────
// Beheert de Bluetooth Low Energy verbinding met de ESP32 armband.
// De ESP32 luistert naar een write-commando op een specifiek characteristic UUID.

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService extends ChangeNotifier {
  static const String _deviceNamePrefix = 'SafeSteps';

  // UUIDs — deze moeten overeenkomen met de ESP32 firmware
  static const String serviceUuid        = '12345678-1234-1234-1234-123456789abc';
  static const String vibrateCharUuid    = '12345678-1234-1234-1234-123456789abd';
  static const String buttonCharUuid     = '12345678-1234-1234-1234-123456789abe';

  BluetoothDevice? _device;
  BluetoothCharacteristic? _vibrateChar;
  BluetoothCharacteristic? _buttonChar;

  bool _isConnected = false;
  bool _isScanning = false;
  String _statusMessage = 'Niet verbonden';

  bool get isConnected => _isConnected;
  bool get isScanning => _isScanning;
  String get statusMessage => _statusMessage;

  // Start scan naar SafeSteps ESP32
  Future<void> startScan() async {
    _isScanning = true;
    _statusMessage = 'Zoeken naar armband…';
    notifyListeners();

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) async {
      for (final r in results) {
        if (r.device.platformName.startsWith(_deviceNamePrefix)) {
          await FlutterBluePlus.stopScan();
          await _connectTo(r.device);
          break;
        }
      }
    });

    FlutterBluePlus.isScanning.listen((scanning) {
      if (!scanning) {
        _isScanning = false;
        if (!_isConnected) {
          _statusMessage = 'Armband niet gevonden';
        }
        notifyListeners();
      }
    });
  }

  Future<void> _connectTo(BluetoothDevice device) async {
    try {
      _statusMessage = 'Verbinden…';
      notifyListeners();

      await device.connect(autoConnect: false);
      _device = device;

      final services = await device.discoverServices();
      for (final s in services) {
        if (s.uuid.toString() == serviceUuid) {
          for (final c in s.characteristics) {
            if (c.uuid.toString() == vibrateCharUuid) _vibrateChar = c;
            if (c.uuid.toString() == buttonCharUuid)  _buttonChar  = c;
          }
        }
      }

      // Luister naar noodknop van armband
      if (_buttonChar != null) {
        await _buttonChar!.setNotifyValue(true);
        _buttonChar!.onValueReceived.listen(_onButtonPress);
      }

      _isConnected = true;
      _statusMessage = 'Armband verbonden';
      notifyListeners();

      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _isConnected = false;
          _statusMessage = 'Verbinding verbroken';
          notifyListeners();
        }
      });
    } catch (e) {
      _statusMessage = 'Verbindingsfout: $e';
      _isConnected = false;
      notifyListeners();
    }
  }

  // Stuur trilsignaal naar armband
  // type: 'short' (zone-melding), 'long' (nood), 'home' (thuis bereikt)
  Future<void> vibrate(String type) async {
    if (_vibrateChar == null || !_isConnected) return;

    final Map<String, List<int>> commands = {
      'short': [0x01],  // 1x kort
      'long':  [0x02],  // 3x lang
      'home':  [0x03],  // zacht patroon
    };

    try {
      await _vibrateChar!.write(commands[type] ?? [0x01]);
    } catch (e) {
      debugPrint('BleService: trilsignaal fout: $e');
    }
  }

  void _onButtonPress(List<int> value) {
    if (value.isEmpty) return;
    if (value[0] == 0x01) {
      // 1x drukken → contactpersoon bellen (implementeer via url_launcher)
      debugPrint('BleService: noodknop 1x gedrukt → bel contact');
    } else if (value[0] == 0x02) {
      // 2x drukken → 112
      debugPrint('BleService: noodknop 2x gedrukt → bel 112');
    }
  }

  Future<void> disconnect() async {
    await _device?.disconnect();
    _isConnected = false;
    _statusMessage = 'Niet verbonden';
    notifyListeners();
  }
}
