part of 'message_bloc.dart';

@immutable
sealed class MessageEvent {}

class LoadChats extends MessageEvent {
  final String? teamId;
  final bool isTeamMessages;
  final String userId;

  LoadChats(this.teamId, this.isTeamMessages, this.userId);
}

class SendMessage extends MessageEvent {
  final Message message;
  final String senderId;
  final String? teamId;

  /// When provided, after sending we refresh this chat's messages instead of chat list.
  final String? chatId;

  SendMessage(this.message, this.senderId, {this.teamId, this.chatId});
}

class LoadMessages extends MessageEvent {
  final String chatId;

  LoadMessages(this.chatId);
}
