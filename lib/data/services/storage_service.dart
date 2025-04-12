import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  Future<bool> set(String key, String value) async {
    await _ensureInitialized();
    return await _prefs.setString(key, value);
  }

  Future<String?> get(String key) async {
    await _ensureInitialized();
    return _prefs.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    await _ensureInitialized();
    return await _prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    await _ensureInitialized();
    return _prefs.getBool(key);
  }

  Future<bool> setInt(String key, int value) async {
    await _ensureInitialized();
    return await _prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    await _ensureInitialized();
    return _prefs.getInt(key);
  }

  Future<bool> remove(String key) async {
    await _ensureInitialized();
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    await _ensureInitialized();
    return await _prefs.clear();
  }

  Future<bool> containsKey(String key) async {
    await _ensureInitialized();
    return _prefs.containsKey(key);
  }

  Future<Set<String>> getKeys() async {
    await _ensureInitialized();
    return _prefs.getKeys();
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }

  // Add cache expiration functionality
  Future<bool> setWithExpiry(String key, String value, Duration expiry) async {
    await _ensureInitialized();
    final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
    await _prefs.setInt('${key}_expiry', expiryTime);
    return await _prefs.setString(key, value);
  }

  Future<String?> getWithExpiry(String key) async {
    await _ensureInitialized();
    
    final expiryTime = _prefs.getInt('${key}_expiry');
    if (expiryTime == null) {
      return _prefs.getString(key); // No expiration set
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    if (now > expiryTime) {
      // Data has expired, remove it
      await _prefs.remove(key);
      await _prefs.remove('${key}_expiry');
      return null;
    }

    return _prefs.getString(key);
  }
} 