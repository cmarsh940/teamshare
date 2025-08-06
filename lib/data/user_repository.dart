import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamshare/models/user.dart';
import 'package:teamshare/utils/app_logger.dart';
import 'package:teamshare/utils/secure_http_client.dart';
import 'package:teamshare/utils/secure_storage.dart';

import '../../constants.dart';

class UserRepository {
  static const String _userTokenKey = 'user_token';
  static const String _userIdKey = 'user_id';
  static const String _isLoginKey = 'is_login';
  static const String _firstTimeKey = 'first_time';
  static const String _themeKey = 'theme';

  Future<User?> authenticate({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SecureHttpClient.post(
        Uri.parse(loginUrl),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        AppLogger.network('Login response received: ${response.statusCode}');
        final Map<String, dynamic> userMap = jsonDecode(response.body);
        final User user = User.fromJson(userMap);
        AppLogger.auth('User authenticated: ${user.email}');

        if (user.id == null) {
          AppLogger.warning('User ID is null in authentication response');
          return null;
        } else {
          final token = user.token ?? 'test'; // Use actual token from response
          final id = user.id!;
          const firstTime = false;

          // Store sensitive data securely
          await SecureStorage.setString(_userTokenKey, token);
          await SecureStorage.setString(_userIdKey, id);
          await SecureStorage.setBool(_isLoginKey, true);
          await SecureStorage.setBool(_firstTimeKey, firstTime);
          await SecureStorage.setBool('asked_for_permissions', false);
          await SecureStorage.setString(_themeKey, 'light');

          return user;
        }
      } else {
        AppLogger.warning(
          'Authentication failed with status: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      AppLogger.error('Authentication error', error: e);
      return null;
    }
  }

  Future<User?> finishSetup(User user) async {
    try {
      final token = await SecureStorage.getString(_userTokenKey);
      final id = user.id;

      if (id == null || token == null) {
        AppLogger.warning('Missing user ID or token for finish setup');
        return null;
      }

      final url = '${finishSetupUrl}$id';
      final body = json.encode(user.toJson());

      final response = await SecureHttpClient.put(
        Uri.parse(url),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userMap = jsonDecode(response.body);
        final User updatedUser = User.fromJson(userMap);

        if (updatedUser.id == null) {
          AppLogger.warning('User ID is null in finish setup response');
          return null;
        } else {
          final firstTime = updatedUser.firstTime;
          await SecureStorage.setBool(_firstTimeKey, firstTime ?? false);
          await SecureStorage.setBool(_isLoginKey, true);
          await SecureStorage.setBool('asked_for_permissions', false);
          await SecureStorage.setString(_themeKey, 'light');
          return updatedUser;
        }
      }
      return null;
    } catch (e) {
      AppLogger.error('Finish setup error', error: e);
      return null;
    }
  }

  Future<void> deleteToken() async {
    await SecureStorage.remove(_userTokenKey);
  }

  Future<String> getId() async {
    return await SecureStorage.getString(_userIdKey) ?? '';
  }

  Future<bool> checkFirstTime() async {
    return await SecureStorage.getBool(_firstTimeKey) ?? false;
  }

  Future<String?> getTheme() async {
    return await SecureStorage.getString(_themeKey);
  }

  Future<void> changeTheme() async {
    final currentTheme = await getTheme();
    if (currentTheme == 'light') {
      await SecureStorage.setString(_themeKey, 'dark');
    } else {
      await SecureStorage.setString(_themeKey, 'light');
    }
  }

  Future<String?> getToken() async {
    return await SecureStorage.getString(_userTokenKey);
  }

  Future<bool?> isSignedIn() async {
    return await SecureStorage.getBool(_isLoginKey);
  }

  Future<dynamic> getUser() async {
    try {
      final token = await getToken();
      final id = await getId();

      if (token == null || id.isEmpty) {
        AppLogger.warning('Missing token or user ID for getUser');
        return null;
      }

      final url = Uri.parse(getUserUrl(id));
      final response = await SecureHttpClient.get(
        url,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        AppLogger.warning(
          'Get user failed with status: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      AppLogger.error('Get user error', error: e);
      return null;
    }
  }

  Future<void> signOut() async {
    AppLogger.auth('Signing out user');
    await SecureStorage.clear();

    // Also clear regular SharedPreferences
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.clear();
  }

  Future<User?> signUp({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPass,
  }) async {
    try {
      final response = await SecureHttpClient.post(
        Uri.parse(registerUrl),
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'confirm_pass': confirmPass,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userMap = jsonDecode(response.body);
        final User user = User.fromJson(userMap);

        if (user.id == null) {
          AppLogger.warning('User ID is null in sign up response');
          return null;
        } else {
          final token = user.token;
          final id = user.id!;
          final firstTime = user.firstTime;

          if (token != null) {
            await SecureStorage.setString(_userTokenKey, token);
            await SecureStorage.setString(_userIdKey, id);
            await SecureStorage.setBool(_isLoginKey, true);
            await SecureStorage.setBool(_firstTimeKey, firstTime ?? false);
            await SecureStorage.setString(_themeKey, 'light');
          }

          return user;
        }
      }
      return null;
    } catch (e) {
      AppLogger.error('Sign up error', error: e);
      return null;
    }
  }

  Future<User?> updateUser(User user) async {
    try {
      final token = await SecureStorage.getString(_userTokenKey);
      final id = user.id;

      if (id == null || token == null) {
        AppLogger.warning('Missing user ID or token for update user');
        return null;
      }

      final url = updateUserUrl(id);
      final body = json.encode(user.toJson());

      final response = await SecureHttpClient.put(
        Uri.parse(url),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = User.fromJson(json.decode(response.body));
        return data;
      } else {
        AppLogger.warning(
          'Update user failed with status: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      AppLogger.error('Update user error', error: e);
      return null;
    }
  }

  // Note: Commented out social auth methods as they appear incomplete
  // and contain only placeholder code. These should be properly implemented
  // if social authentication is required.
}
