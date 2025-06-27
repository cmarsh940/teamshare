import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../constants.dart';

class NotificationRepository {
  // This class will handle the logic for notifications.
  // It can include methods to fetch, create, update, and delete notifications.

  // Example method to fetch notifications
  Future<List<dynamic>> fetchNotifications(String id) async {
    http.Response response = await http.get(
      Uri.parse(fetchNotificationUrl(id)),
    );

    final List<dynamic> decoded = jsonDecode(response.body);
    return decoded;
  }
}
