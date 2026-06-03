// ─── services/storage_service.dart ───────────────────────────────────────────

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/walk_session.dart';

class StorageService extends ChangeNotifier {
  Database? _db;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dbPath, 'steply.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE walk_sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            start_time TEXT NOT NULL,
            end_time TEXT,
            distance_km REAL NOT NULL,
            duration_seconds INTEGER NOT NULL,
            zone_warnings INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> saveWalk(WalkSession session) async {
    await _ensureDb();
    final id = await _db!.insert('walk_sessions', session.toMap());
    notifyListeners();
    return id;
  }

  Future<List<WalkSession>> getRecentWalks({int limit = 20}) async {
    await _ensureDb();
    final maps = await _db!.query('walk_sessions', orderBy: 'start_time DESC', limit: limit);
    return maps.map(WalkSession.fromMap).toList();
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    notifyListeners();
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> _ensureDb() async {
    if (_db == null) await init();
  }
}
