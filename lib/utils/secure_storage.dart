import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_logger.dart';

/// Secure storage utility for sensitive data with encryption
class SecureStorage {
  static const String _keyPrefix = 'secure_';
  static String? _encryptionKey;

  static String get _key {
    _encryptionKey ??= _generateEncryptionKey();
    return _encryptionKey!;
  }

  static String _generateEncryptionKey() {
    // In production, derive this from device-specific data or use
    // flutter_secure_storage or similar package
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
        32,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  static String _encrypt(String data) {
    // Simple XOR encryption - in production use proper encryption
    final key = _key;
    final encrypted = <int>[];

    for (int i = 0; i < data.length; i++) {
      encrypted.add(data.codeUnitAt(i) ^ key.codeUnitAt(i % key.length));
    }

    return base64Encode(encrypted);
  }

  static String _decrypt(String encryptedData) {
    try {
      final key = _key;
      final encrypted = base64Decode(encryptedData);
      final decrypted = <int>[];

      for (int i = 0; i < encrypted.length; i++) {
        decrypted.add(encrypted[i] ^ key.codeUnitAt(i % key.length));
      }

      return String.fromCharCodes(decrypted);
    } catch (e) {
      throw Exception('Failed to decrypt data: $e');
    }
  }

  /// Securely store a string value
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedValue = _encrypt(value);
    await prefs.setString('$_keyPrefix$key', encryptedValue);
  }

  /// Securely retrieve a string value
  static Future<String?> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encryptedValue = prefs.getString('$_keyPrefix$key');
      if (encryptedValue == null) return null;
      return _decrypt(encryptedValue);
    } catch (e) {
      AppLogger.error('Error retrieving secure value for key $key: $e');
      return null;
    }
  }

  /// Securely store a boolean value
  static Future<void> setBool(String key, bool value) async {
    await setString(key, value.toString());
  }

  /// Securely retrieve a boolean value
  static Future<bool?> getBool(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  /// Remove a secure value
  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyPrefix$key');
  }

  /// Clear all secure data
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_keyPrefix)) {
        await prefs.remove(key);
      }
    }
  }

  /// Generate a secure hash for passwords
  static String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate a random salt
  static String generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(saltBytes);
  }
}
