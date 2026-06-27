import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Debug-only toggles for testing progression without grinding coins.
abstract final class DeveloperOptions {
  static const _unlockAllStoreKey = 'dev_unlock_all_store';

  static bool _unlockAllStoreItems = false;

  /// Whether developer options can be used (debug/profile builds only).
  static bool get isAvailable => !kReleaseMode;

  /// When true, every store item is treated as owned and free to equip.
  static bool get unlockAllStoreItems => isAvailable && _unlockAllStoreItems;

  static Future<void> initialize() async {
    if (!isAvailable) return;
    final prefs = await SharedPreferences.getInstance();
    _unlockAllStoreItems = prefs.getBool(_unlockAllStoreKey) ?? false;
  }

  static Future<void> setUnlockAllStoreItems(bool value) async {
    if (!isAvailable) return;
    _unlockAllStoreItems = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_unlockAllStoreKey, value);
  }
}
