import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/message_repository.dart';
import 'package:teamshare/models/chat.dart';
import 'package:teamshare/models/message.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository _messageRepository = GetIt.I<MessageRepository>();

  MessageBloc() : super(MessageInitial()) {
    on<LoadChats>(_mapLoadChatsToState);
    on<SendMessage>(_mapSendMessageToState);
    on<LoadMessages>(_mapLoadMessagesToState);
  }

  _mapLoadChatsToState(LoadChats event, Emitter<MessageState> emit) async {
    emit(LoadingMessages());
    try {
      final messages = await _messageRepository.fetchMessages(
        event.userId,
        event.isTeamMessages,
        event.teamId,
      );

      emit(ChatLoaded(messages));
    } catch (error) {
      emit(ErrorLoadingMessages(error.toString()));
    }
  }

  _mapSendMessageToState(SendMessage event, Emitter<MessageState> emit) async {
    try {
      await _messageRepository.sendMessage(
        event.message,
        event.senderId,
        teamId: event.teamId,
      );
      emit(MessageSent());
      if (event.chatId != null) {
        add(LoadMessages(event.chatId!));
      } else {
        add(LoadChats(event.teamId, event.teamId != null, event.senderId));
      }
    } catch (error) {
      emit(ErrorLoadingMessages(error.toString()));
    }
  }

  _mapLoadMessagesToState(
    LoadMessages event,
    Emitter<MessageState> emit,
  ) async {
    emit(LoadingMessages());
    try {
      final messages = await _messageRepository.fetchMessagesByChatId(
        event.chatId,
      );
      emit(MessagesLoaded(messages));
    } catch (error) {
      emit(ErrorLoadingMessages(error.toString()));
    }
  }
}
