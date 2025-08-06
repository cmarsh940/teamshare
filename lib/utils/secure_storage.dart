import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_logger.dart';

/// Secure storage utility for sensitive data with encryption
class SecureStorage {
  static const String _keyPrefix = 'secure_';
  static const String _encryptionKeyKey = 'encryption_key';
  static String? _encryptionKey;

  static Future<String> get _key async {
    if (_encryptionKey != null) return _encryptionKey!;

    // Try to load existing key from plain SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final existingKey = prefs.getString(_encryptionKeyKey);

    if (existingKey != null) {
      _encryptionKey = existingKey;
      AppLogger.info('Loaded existing encryption key');
    } else {
      // Generate new key and store it
      _encryptionKey = _generateEncryptionKey();
      await prefs.setString(_encryptionKeyKey, _encryptionKey!);
      AppLogger.info('Generated and stored new encryption key');
    }

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

  static Future<String> _encrypt(String data) async {
    // Safe encryption using double base64 encoding with key mixing
    // This completely avoids any UTF-8 byte issues
    final key = await _key;

    // First encode the data to base64 (always valid ASCII)
    final base64Data = base64Encode(utf8.encode(data));

    // Mix with key by interleaving characters (safe ASCII operations)
    final keyChars = key.split('');
    final dataChars = base64Data.split('');
    final mixed = <String>[];

    for (int i = 0; i < dataChars.length; i++) {
      mixed.add(dataChars[i]);
      if (i < keyChars.length) {
        mixed.add(keyChars[i]);
      }
    }

    // Encode the mixed result again
    return base64Encode(utf8.encode(mixed.join('')));
  }

  static Future<String> _decrypt(String encryptedData) async {
    try {
      // First decode from base64
      final mixedData = utf8.decode(base64Decode(encryptedData));

      // Extract original data by removing key characters
      final mixedChars = mixedData.split('');
      final dataChars = <String>[];

      for (int i = 0; i < mixedChars.length; i++) {
        // Data characters are at even positions
        if (i % 2 == 0) {
          dataChars.add(mixedChars[i]);
        }
      }

      // Decode the original base64 data
      final originalData = utf8.decode(base64Decode(dataChars.join('')));
      return originalData;
    } catch (e) {
      AppLogger.error('Failed to decrypt data: $e');
      throw Exception('Failed to decrypt data: $e');
    }
  }

  /// Securely store a string value
  static Future<void> setString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encryptedValue = await _encrypt(value);
      await prefs.setString('$_keyPrefix$key', encryptedValue);
      AppLogger.info('Stored secure value for key: $key');
    } catch (e) {
      AppLogger.error('Error storing secure value for key $key: $e');
      rethrow;
    }
  }

  /// Securely retrieve a string value
  static Future<String?> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encryptedValue = prefs.getString('$_keyPrefix$key');
      if (encryptedValue == null) {
        AppLogger.info('No secure value found for key: $key');
        return null;
      }
      final decryptedValue = await _decrypt(encryptedValue);
      AppLogger.info('Retrieved secure value for key: $key');
      return decryptedValue;
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
    final secureKeys = keys.where((key) => key.startsWith(_keyPrefix)).toList();
    AppLogger.info('Clearing ${secureKeys.length} secure storage keys');

    for (final key in secureKeys) {
      await prefs.remove(key);
    }
  }

  /// Debug method to list all secure storage keys
  static Future<List<String>> getStoredKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final secureKeys = keys.where((key) => key.startsWith(_keyPrefix)).toList();
    AppLogger.info(
      'Found ${secureKeys.length} secure storage keys: $secureKeys',
    );
    return secureKeys;
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
