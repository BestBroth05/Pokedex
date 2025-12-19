import 'dart:convert';
import 'package:hive/hive.dart';

class LocalCache {
  static const _boxName = 'pokedex_cache_v1';
  static late Box _box;

  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<void> putJson(String key, Map<String, dynamic> json) async {
    await _box.put(key, jsonEncode(json));
  }

  Map<String, dynamic>? getJson(String key) {
    final raw = _box.get(key);
    if (raw is! String) return null;
    try {
      return (jsonDecode(raw) as Map).cast<String, dynamic>();
    } catch (_) {
      return null;
    }
  }

  Future<void> delete(String key) => _box.delete(key);
}
