class MessageRepository {
  // This class will handle the data operations related to messages.
  // It can include methods for fetching, sending, and deleting messages.

  // Example method to fetch messages
  Future<List<String>> fetchMessages() async {
    // Simulate a network call or database query
    await Future.delayed(Duration(seconds: 1));
    return ["Hello", "How are you?", "Goodbye"];
  }

  // Example method to send a message
  Future<void> sendMessage(String message) async {
    // Simulate sending a message
    await Future.delayed(Duration(seconds: 1));
    print("Message sent: $message");
  }
}
