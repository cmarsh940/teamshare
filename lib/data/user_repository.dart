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
        final Map<String, dynamic> responseMap = jsonDecode(response.body);

        // Check if token exists at the root level of the response
        final rootToken = responseMap['token'] as String?;

        // Extract the user object from the nested response (same as signUp)
        final Map<String, dynamic> userMap =
            responseMap['user'] as Map<String, dynamic>;
        final User user = User.fromJson(userMap);

        AppLogger.auth('User authenticated: ${user.email}');

        if (user.id == null) {
          AppLogger.warning('User ID is null in authentication response');
          return null;
        } else {
          // Use token from root level if user token is null
          final token = user.token ?? rootToken;
          final id = user.id!;
          const firstTime = false;

          if (token != null) {
            // Store user data securely
            await SecureStorage.setString(_userTokenKey, token);
            await SecureStorage.setString(_userIdKey, id);
            await SecureStorage.setBool(_isLoginKey, true);
            await SecureStorage.setBool(_firstTimeKey, firstTime);
            await SecureStorage.setBool('asked_for_permissions', false);
            await SecureStorage.setString(_themeKey, 'light');

            AppLogger.info('User data stored successfully after login');
          } else {
            AppLogger.warning(
              'Token missing, storing user data without token for development',
            );

            // Store user data even without token for development purposes
            await SecureStorage.setString(_userTokenKey, 'dev-token');
            await SecureStorage.setString(_userIdKey, id);
            await SecureStorage.setBool(_isLoginKey, true);
            await SecureStorage.setBool(_firstTimeKey, firstTime);
            await SecureStorage.setBool('asked_for_permissions', false);
            await SecureStorage.setString(_themeKey, 'light');
          }

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
    final result = await SecureStorage.getString(_userIdKey) ?? '';

    // Check if the ID looks corrupted (contains non-printable characters)
    final isCorrupted =
        result.contains(RegExp(r'[^\w\-]')) && result.isNotEmpty;

    if (result.isEmpty) {
      AppLogger.warning('User ID is empty! This will cause API failures.');
    } else if (isCorrupted) {
      AppLogger.error('User ID appears corrupted, clearing storage');
      await SecureStorage.clear();
      return '';
    }

    return result;
  }

  Future<bool> checkFirstTime() async {
    final result = await SecureStorage.getBool(_firstTimeKey) ?? false;
    AppLogger.info('checkFirstTime result: $result');
    return result;
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
    final result = await SecureStorage.getString(_userTokenKey);
    AppLogger.info(
      'getToken result: ${result != null ? 'Token exists' : 'No token'}',
    );
    return result;
  }

  Future<bool?> isSignedIn() async {
    // Check if stored data is corrupted before proceeding
    final userId = await SecureStorage.getString(_userIdKey) ?? '';
    if (userId.isNotEmpty) {
      final isCorrupted = userId.contains(RegExp(r'[^\w\-]'));
      if (isCorrupted) {
        AppLogger.error('Detected corrupted user data during sign-in check');
        await SecureStorage.clear();
        return false;
      }
    }

    final result = await SecureStorage.getBool(_isLoginKey);
    return result;
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

      if (response.statusCode == 201) {
        // Log response body for debugging
        AppLogger.network('Sign up response received: ${response.statusCode}');
        AppLogger.network('Response body: ${response.body}');
        final Map<String, dynamic> responseMap = jsonDecode(response.body);

        // Extract the user object from the nested response
        final Map<String, dynamic> userMap =
            responseMap['user'] as Map<String, dynamic>;
        final User user = User.fromJson(userMap);

        // Log the entire user object for debugging
        AppLogger.auth('User signed up: ${user.toJson()}');

        if (user.id == null) {
          AppLogger.warning('User ID is null in sign up response');
          return null;
        } else {
          final token = user.token;
          final id = user.id!;
          // For new registrations, set firstTime to false so they go directly to authenticated state
          const firstTime = false;

          if (token != null) {
            AppLogger.info('Storing user data after signup:');
            AppLogger.info('- Token: ${token.substring(0, 10)}...');
            AppLogger.info('- User ID: $id');
            AppLogger.info('- First time: $firstTime');

            // Store user data securely
            await SecureStorage.setString(_userTokenKey, token);
            await SecureStorage.setString(_userIdKey, id);
            await SecureStorage.setBool(_isLoginKey, true);
            await SecureStorage.setBool(_firstTimeKey, firstTime);
            await SecureStorage.setString(_themeKey, 'light');

            AppLogger.info('User data stored successfully');
          } else {
            AppLogger.warning('Token is null, not storing user data');
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
