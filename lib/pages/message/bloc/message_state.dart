part of 'message_bloc.dart';

@immutable
sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class LoadingMessages extends MessageState {}

final class MessageLoaded extends MessageState {
  final List<dynamic> messages;

  MessageLoaded(this.messages);
}

final class ErrorLoadingMessages extends MessageState {
  final String error;

  ErrorLoadingMessages(this.error);
}

final class MessagesEmpty extends MessageState {}
