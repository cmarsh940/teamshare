part of 'first_time_bloc.dart';

@immutable
abstract class FirstTimeEvent {}

class Submitted extends FirstTimeEvent {
  final User user;
  final bool changed;

  Submitted({
    required this.user,
    required this.changed,
  });

  @override
  String toString() {
    return 'Submitted ';
  }
}

class ChannelChanged extends FirstTimeEvent {
  final String channel;

  ChannelChanged({required this.channel});

  @override
  String toString() => 'ChannelChanged { channel: $channel }';
}