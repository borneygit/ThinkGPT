import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

@lazySingleton
class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionStateInit());

  Future<void> loadSessions() async {
    final repository = await getIt.getAsync<ChatRepository>();
    final sessions = await repository.findAllSessions();
    final lastSession = await repository.findLastSession();

    emit(SessionStateLoaded(sessions: sessions, activeSession: lastSession));
  }

  Future<void> setActiveSession(Session? session) async {
    emit(SessionStateActive(sessions: state.sessions, activeSession: session));
  }

  Future<Session> upsertSession(Session? session) async {
    if (session != null) {
      final repository = await getIt.getAsync<ChatRepository>();
      session = await repository.upsertSession(session);
      final index = state.sessions.indexWhere((ele) => ele.id == session!.id);
      if (index != -1) {
        state.sessions[index] = session;
      } else {
        state.sessions = [session, ...state.sessions];
      }
    }
    if (state.activeSession?.id == session?.id) {
      emit(SessionStateUpdated(
          sessions: state.sessions, activeSession: state.activeSession));
    } else {
      emit(
          SessionStateActive(sessions: state.sessions, activeSession: session));
    }
    return session!;
  }

  void delete(Session session) async {
    final repository = await getIt.getAsync<ChatRepository>();
    await repository.deleteSession(session);
    state.sessions.remove(session);
    if (state.sessions.isEmpty) {
      emit(SessionStateActive(sessions: state.sessions, activeSession: null));
    } else if (state.activeSession?.id == session.id) {
      emit(SessionStateActive(sessions: state.sessions, activeSession: null));
    } else {
      emit(SessionStateDeleted(
          sessions: state.sessions, activeSession: state.activeSession));
    }
  }
}

abstract class SessionState {
  List<Session> sessions;
  Session? activeSession;

  SessionState({required this.sessions, required this.activeSession});
}

class SessionStateInit extends SessionState {
  SessionStateInit() : super(sessions: [], activeSession: null);
}

class SessionStateActive extends SessionState {
  SessionStateActive({required super.sessions, required super.activeSession});
}

class SessionStateLoaded extends SessionState {
  SessionStateLoaded({required super.sessions, required super.activeSession});
}

class SessionStateUpdated extends SessionState {
  SessionStateUpdated({required super.sessions, required super.activeSession});
}

class SessionStateDeleted extends SessionState {
  SessionStateDeleted({required super.sessions, required super.activeSession});
}
