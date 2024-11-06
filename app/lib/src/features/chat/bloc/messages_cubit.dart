import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import 'session_cubit.dart';

part 'messages_cubit.freezed.dart';

@lazySingleton
class MessageCubit extends Cubit<MessageState> {
  final SessionCubit _sessionCubit;

  MessageCubit(this._sessionCubit) : super(const MessageState()) {
    _sessionCubit.stream.listen((sessionState) async {
      if (sessionState is SessionStateActive ||
          sessionState is SessionStateLoaded) {
        await loadMessages(sessionState.activeSession);
      }
    });
  }

  Future<void> loadMessages(Session? session) async {
    final repository = await getIt.getAsync<ChatRepository>();
    String sessionId = session?.id ?? '';
    if (sessionId.isNotEmpty) {
      final messages = await repository.findMessagesBySessionId(sessionId);
      emit(state.copyWith(messages: messages));
    } else {
      emit(state.copyWith(messages: []));
    }
  }

  Future<void> addOrUpdateMessage(Message message) async {
    final repository = await getIt.getAsync<ChatRepository>();
    await repository.upsertMessage(message);
    final index = state.messages.indexWhere((m) => m.id == message.id);
    var messages = List<Message>.empty();
    if (index == -1) {
      messages = [...state.messages, message];
    } else {
      messages = [...state.messages]..[index] = message;
    }
    emit(state.copyWith(messages: messages));
  }
}

@freezed
class MessageState with _$MessageState {
  const factory MessageState({
    @Default([]) List<Message> messages,
  }) = _MessageState;
}
