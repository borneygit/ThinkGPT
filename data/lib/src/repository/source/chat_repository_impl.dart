import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import 'api/chat_service.dart';
import 'database/app_database_repository.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatService _chatService;
  final AppDatabaseRepository _appDatabaseRepository;

  ChatRepositoryImpl(this._chatService, this._appDatabaseRepository);

  @override
  Future<String> sendMessage(Message message) {
    return _chatService.sendMessage(message);
  }

  @override
  Stream<String> streamChat(List<Message> messages, String model) {
    return _chatService.streamChat(messages, model);
  }

  @override
  Future<List<Message>> findAllMessages() {
    return _appDatabaseRepository.findAllMessages();
  }

  @override
  Future<List<Message>> findMessagesBySessionId(String sessionId) {
    return _appDatabaseRepository.findMessagesBySessionId(sessionId);
  }

  @override
  Future<void> upsertMessage(Message message) {
    return _appDatabaseRepository.upsertMessage(message);
  }

  @override
  Future<List<Session>> findAllSessions() {
    return _appDatabaseRepository.findAllSessions();
  }

  @override
  Future<Session?> findSessionById(int sessionId) {
    return _appDatabaseRepository.findSessionById(sessionId);
  }

  @override
  Future<Session> upsertSession(Session session) {
    return _appDatabaseRepository.upsertSession(session);
  }

  @override
  Future<Session?> findLastSession() {
    return _appDatabaseRepository.findLastSession();
  }

  @override
  Future<void> deleteSession(Session session) {
    return _appDatabaseRepository.deleteSession(session);
  }
}
