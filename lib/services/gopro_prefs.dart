import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:heroctrl/models/gopro_registration.dart';

class GoProPrefs {
  static final String _key = 'registered_gopros';
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<List<GoProRegistration>> _loadAll() async {
    final s = await _secureStorage.read(key: _key);
    if (s == null) return [];
    final list = (json.decode(s) as List).cast<Map<String, dynamic>>();
    return list
        .map((m) => GoProRegistration.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  static Future<void> _saveAll(List<GoProRegistration> items) async {
    await _secureStorage.write(
      key: _key,
      value: json.encode(items.map((e) => e.toJson()).toList()),
    );
  }

  static Future<List<GoProRegistration>> getAll() => _loadAll();

  static Future<void> add(GoProRegistration item) async {
    final items = await _loadAll();
    if (items.any((e) => e.bssid == item.bssid)) return; // avoid dup
    items.add(item);
    await _saveAll(items);
  }

  static Future<bool> removeByBssid(String bssid) async {
    final items = await _loadAll();
    final filtered = items.where((e) => e.bssid != bssid).toList();
    if (filtered.length == items.length) return false;
    await _saveAll(filtered);
    return true;
  }

  static Future<GoProRegistration?> findByBssid(String bssid) async {
    final items = await _loadAll();
    try {
      return items.firstWhere((e) => e.bssid == bssid);
    } catch (_) {
      return null;
    }
  }
}
