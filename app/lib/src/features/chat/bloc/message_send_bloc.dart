import 'dart:async';
import 'package:app/src/features/chat/bloc/messages_cubit.dart';
import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

part 'message_send_bloc.freezed.dart';

@injectable
class MessageSenderBloc extends Bloc<MessageSendEvent, MessageSendState> {
  final MessageCubit _messagesCubit;
  final SessionCubit _sessionCubit;
  StreamSubscription? _chatSubscription;
  Completer<void>? _completer;

  MessageSenderBloc(this._messagesCubit, this._sessionCubit)
      : super(const MessageSendState.initial()) {
    on<_SendMessage>((event, emit) async {
      await _onSendMessage(event, emit);
    });

    on<_StopSending>((event, emit) async {
      await _onStopSending(emit);
    });
  }

  @override
  Future<void> close() {
    _cleanup();
    return super.close();
  }

  Future<void> _onSendMessage(
      _SendMessage event, Emitter<MessageSendState> emit) async {
    emit(const MessageSendState.sending());
    try {
      final repository = await getIt.getAsync<ChatRepository>();
      final userMessage = event.message;
      await _messagesCubit.addOrUpdateMessage(userMessage);
      final id = getIt<Uuid>().v4();

      var message = Message(
          id: id,
          content: "",
          isUser: false,
          timestamp: DateTime.now(),
          sessionId: event.session.id);

      _completer = Completer<void>();
      var buffer = StringBuffer();

      Future<void> updateMessage() async {
        if (buffer.isEmpty || emit.isDone) return;
        final newContent = buffer.toString();
        buffer.clear();
        message = message.copyWith(content: message.content + newContent);
        _messagesCubit.addOrUpdateMessage(message);
      }

      final debounceTimer =
          Timer.periodic(const Duration(milliseconds: 10), (timer) {
        updateMessage();
      });
      _chatSubscription = repository
          .streamChat(_messagesCubit.state.messages, event.session.model)
          .listen((text) async {
        if (!(_completer?.isCompleted ?? true)) {
          buffer.write(text);
        }
      }, onError: (e) {
        emit(MessageSendState.failure(AppException.fromError(e)));
        return;
      }, onDone: () async {
        await updateMessage();
        debounceTimer.cancel();
        if (!(_completer?.isCompleted ?? true)) {
          _completer?.complete();
        }
      });

      _sessionCubit
          .upsertSession(event.session.copyWith(updatedAt: DateTime.now()));

      await _completer?.future;

      emit(const MessageSendState.success());
    } catch (e) {
      emit(
          MessageSendState.failure(AppException.fromException(e as Exception)));
    }
  }

  Future<void> _onStopSending(Emitter<MessageSendState> emit) async {
    _cleanup();
    emit(const MessageSendState.stopped());
  }

  void _cleanup() {
    _chatSubscription?.cancel();
    if (!(_completer?.isCompleted ?? true)) {
      _completer?.complete();
    }
    _chatSubscription = null;
    _completer = null;
  }
}

@freezed
class MessageSendEvent with _$MessageSendEvent {
  const factory MessageSendEvent.sendMessage(Message message, Session session) =
      _SendMessage;

  const factory MessageSendEvent.stopSending() = _StopSending;
}

@freezed
class MessageSendState with _$MessageSendState {
  const factory MessageSendState.initial() = _Initial;

  const factory MessageSendState.sending() = Sending;

  const factory MessageSendState.success() = Success;

  factory MessageSendState.failure(AppException e) = Failure;

  const factory MessageSendState.stopped() = Stopped;
}
