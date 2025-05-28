import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInitial()) {
    on<LoadMessages>(_mapLoadMessagesToState);
  }

  _mapLoadMessagesToState(
    LoadMessages event,
    Emitter<MessageState> emit,
  ) async {
    emit(LoadingMessages());
    try {
      // Simulate fetching notifications
      await Future.delayed(Duration(seconds: 2));
      final messages = []; // Replace with actual notification fetching logic
      if (messages.isEmpty) {
        emit(MessagesEmpty());
      } else {
        emit(MessageLoaded(messages));
      }
    } catch (error) {
      emit(ErrorLoadingMessages(error.toString()));
    }
  }
}
