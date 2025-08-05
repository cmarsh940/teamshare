part of 'message_bloc.dart';

@immutable
sealed class MessageEvent {}

class LoadMessages extends MessageEvent {
  final String? teamId;
  final bool isTeamMessages;
  final String userId;

  LoadMessages(this.teamId, this.isTeamMessages, this.userId);
}

class SendMessage extends MessageEvent {
  final String message;

  SendMessage(this.message);
}
