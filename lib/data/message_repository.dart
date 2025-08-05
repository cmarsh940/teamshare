import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants.dart';

class MessageRepository {
  // This class will handle the data operations related to messages.
  // It can include methods for fetching, sending, and deleting messages.

  Future<List<String>> fetchMessages(
    String id,
    bool isTeamMessage,
    String? teamId,
  ) async {
    http.Response response = await http.get(
      Uri.parse(fetchMessagesUrl(id, isTeamMessage, teamId)),
    );
    if (response.statusCode == 404) {
      return [];
    } else if (response.statusCode != 200) {
      throw Exception('Failed to load messages');
    }
    final List<dynamic> decoded = jsonDecode(response.body);
    return decoded.map((message) => message.toString()).toList();
  }

  // Example method to send a message
  Future<void> sendMessage(String message) async {
    // Simulate sending a message
    await Future.delayed(Duration(seconds: 1));
    print("Message sent: $message");
  }
}
