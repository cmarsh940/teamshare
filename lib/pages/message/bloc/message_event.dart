part of 'message_bloc.dart';

@immutable
sealed class MessageEvent {}

class LoadMessages extends MessageEvent {
  final String? teamId;

  LoadMessages(this.teamId);
}
