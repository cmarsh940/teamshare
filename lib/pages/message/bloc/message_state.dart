part of 'message_bloc.dart';

@immutable
sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class LoadingMessages extends MessageState {}

final class ChatLoaded extends MessageState {
  final List<Chat> messages;

  ChatLoaded(this.messages);
}

final class MessageEmpty extends MessageState {}

final class ErrorLoadingMessages extends MessageState {
  final String error;

  ErrorLoadingMessages(this.error);
}

final class MessagesEmpty extends MessageState {}

final class MessageSent extends MessageState {}

final class MessagesLoaded extends MessageState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
}
