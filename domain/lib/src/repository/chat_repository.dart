import 'package:domain/domain.dart';

abstract class ChatRepository {
  Future<String> sendMessage(Message message);

  Stream<String> streamChat(List<Message> messages, String model);

  Future<List<Message>> findAllMessages();

  Future<void> upsertMessage(Message message);

  Future<List<Message>> findMessagesBySessionId(String sessionId);

  Future<List<Session>> findAllSessions();

  Future<Session?> findSessionById(int sessionId);

  Future<Session> upsertSession(Session session);

  Future<Session?> findLastSession();

  Future<void> deleteSession(Session session);
}
