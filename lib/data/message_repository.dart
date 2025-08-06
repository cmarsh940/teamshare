import 'dart:convert';
import '../constants.dart';
import '../utils/secure_http_client.dart';
import '../utils/app_logger.dart';

class MessageRepository {
  /// Fetch messages for a user or team
  Future<List<String>> fetchMessages(
    String id,
    bool isTeamMessage,
    String? teamId,
  ) async {
    try {
      final uri = Uri.parse(fetchMessagesUrl(id, isTeamMessage, teamId));
      final response = await SecureHttpClient.get(uri);

      if (response.statusCode == 404) {
        return [];
      } else if (response.statusCode != 200) {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }

      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((message) => message.toString()).toList();
    } catch (e) {
      AppLogger.error('Failed to fetch messages: $e');
      throw Exception('Failed to fetch messages: $e');
    }
  }

  /// Send a message
  Future<void> sendMessage(
    String message,
    String recipientId, {
    String? teamId,
  }) async {
    try {
      final uri = Uri.parse(
        teamId != null
            ? '$baseUrl/teams/$teamId/messages'
            : '$baseUrl/users/$recipientId/messages',
      );

      final response = await SecureHttpClient.post(
        uri,
        body: jsonEncode({
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to send message: ${response.statusCode}');
      }

      AppLogger.info('Message sent successfully');
    } catch (e) {
      AppLogger.error('Failed to send message: $e');
      throw Exception('Failed to send message: $e');
    }
  }
}
