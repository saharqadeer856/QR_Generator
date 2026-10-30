import 'dart:convert';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/qr_item.dart';

/// Reads and writes saved codes and settings on the device.
class StorageService extends GetxService {
  static const int maxHistory = 50;
  static const String _historyKey = 'saved_qr_codes';
  static const String _levelKey = 'default_error_level';

  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  List<QrItem> loadHistory() {
    final raw = _prefs.getStringList(_historyKey) ?? const <String>[];
    return raw
        .map((e) => QrItem.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveHistory(List<QrItem> items) => _prefs.setStringList(
        _historyKey,
        items.map((e) => jsonEncode(e.toJson())).toList(),
      );

  Future<void> clearHistory() => _prefs.remove(_historyKey);

  int get defaultErrorLevel => _prefs.getInt(_levelKey) ?? QrErrorCorrectLevel.M;

  Future<void> setDefaultErrorLevel(int level) =>
      _prefs.setInt(_levelKey, level);
}
