import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heroctrl/models/gopro_registration.dart';

class GoProPrefs {
  static const _key = 'registered_gopros';

  Future<List<GoProRegistration>> _loadAll() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString(_key);
    if (s == null) return [];
    final list = (json.decode(s) as List).cast<Map<String, dynamic>>();
    return list
        .map((m) => GoProRegistration.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  Future<void> _saveAll(List<GoProRegistration> items) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(
      _key,
      json.encode(items.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<GoProRegistration>> getAll() => _loadAll();

  Future<void> add(GoProRegistration item) async {
    final items = await _loadAll();
    if (items.any((e) => e.bssid == item.bssid)) return; // avoid dup
    items.add(item);
    await _saveAll(items);
  }

  Future<bool> removeByBssid(String bssid) async {
    final items = await _loadAll();
    final filtered = items.where((e) => e.bssid != bssid).toList();
    if (filtered.length == items.length) return false;
    await _saveAll(filtered);
    return true;
  }

  Future<GoProRegistration?> findByBssid(String bssid) async {
    final items = await _loadAll();
    try {
      return items.firstWhere((e) => e.bssid == bssid);
    } catch (_) {
      return null;
    }
  }
}
