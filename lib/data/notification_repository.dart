import 'dart:convert';
import '../constants.dart';
import '../utils/secure_http_client.dart';
import '../utils/app_logger.dart';

class NotificationRepository {
  /// Fetch notifications for a user
  Future<List<dynamic>> fetchNotifications(String id) async {
    try {
      final uri = Uri.parse(fetchNotificationUrl(id));
      final response = await SecureHttpClient.get(uri);

      if (response.statusCode == 404) {
        return [];
      } else if (response.statusCode != 200) {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }

      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded;
    } catch (e) {
      AppLogger.error('Failed to fetch notifications: $e');
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final uri = Uri.parse('${notificationDetailUrl(notificationId)}/read');
      final response = await SecureHttpClient.patch(
        uri,
        body: jsonEncode({'read': true}),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to mark notification as read: ${response.statusCode}',
        );
      }

      AppLogger.info('Notification marked as read');
    } catch (e) {
      AppLogger.error('Failed to mark notification as read: $e');
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final uri = Uri.parse(notificationDetailUrl(notificationId));
      final response = await SecureHttpClient.delete(uri);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to delete notification: ${response.statusCode}',
        );
      }

      AppLogger.info('Notification deleted');
    } catch (e) {
      AppLogger.error('Failed to delete notification: $e');
      throw Exception('Failed to delete notification: $e');
    }
  }
}
