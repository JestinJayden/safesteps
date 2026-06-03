import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService extends ChangeNotifier {
  static const String _deviceNamePrefix = 'Steply';
  static const String serviceUuid     = '12345678-1234-1234-1234-123456789abc';
  static const String vibrateCharUuid = '12345678-1234-1234-1234-123456789abd';
  static const String buttonCharUuid  = '12345678-1234-1234-1234-123456789abe';

  BluetoothDevice? _device;
  BluetoothCharacteristic? _vibrateChar;
  BluetoothCharacteristic? _buttonChar;
  bool _isConnected = false;
  bool _isScanning = false;
  int _battery = 86;
  String _statusMessage = 'Niet verbonden';

  bool get isConnected => _isConnected;
  bool get isScanning => _isScanning;
  int get battery => _battery;
  String get statusMessage => _statusMessage;

  Future<void> startScan() async {
    _isScanning = true;
    _statusMessage = 'Zoeken naar armband…';
    notifyListeners();
    try {
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
          if (!_isConnected) _statusMessage = 'Armband niet gevonden';
          notifyListeners();
        }
      });
    } catch (e) {
      _isScanning = false;
      _statusMessage = 'Bluetooth niet beschikbaar';
      notifyListeners();
    }
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
            if (c.uuid.toString() == buttonCharUuid) _buttonChar = c;
          }
        }
      }
      if (_buttonChar != null) {
        await _buttonChar!.setNotifyValue(true);
        _buttonChar!.onValueReceived.listen(_onButtonPress);
      }
      _isConnected = true;
      _statusMessage = 'Verbonden';
      notifyListeners();
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _isConnected = false;
          _statusMessage = 'Verbinding verbroken';
          notifyListeners();
        }
      });
    } catch (e) {
      _statusMessage = 'Verbindingsfout';
      _isConnected = false;
      notifyListeners();
    }
  }

  Future<void> vibrate(String type) async {
    if (_vibrateChar == null || !_isConnected) return;
    final commands = {'short': [0x01], 'long': [0x02], 'home': [0x03]};
    try { await _vibrateChar!.write(commands[type] ?? [0x01]); } catch (_) {}
  }

  void _onButtonPress(List<int> value) {
    if (value.isEmpty) return;
    debugPrint('Noodknop gedrukt: ${value[0]}');
  }

  Future<void> disconnect() async {
    await _device?.disconnect();
    _isConnected = false;
    _statusMessage = 'Niet verbonden';
    notifyListeners();
  }
}
