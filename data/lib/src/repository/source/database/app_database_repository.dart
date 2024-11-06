import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import 'app_database.dart';
import 'mapper/local_message_mapper.dart';
import 'mapper/local_session_mapper.dart';

@lazySingleton
class AppDatabaseRepository {
  final AppDatabase _db;

  AppDatabaseRepository._(this._db);

  @factoryMethod
  static Future<AppDatabaseRepository> create() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .addMigrations([]).build();
    return AppDatabaseRepository._(database);
  }

  Future<List<Message>> findAllMessages() async {
    final localMessages = await _db.messageDao.findAllMessages();
    return getIt<LocalMessageMapper>().mapToListEntity(localMessages);
  }

  Future<List<Message>> findMessagesBySessionId(String sessionId) async {
    final localMessages =
        await _db.messageDao.findMessagesBySessionId(sessionId);
    return getIt<LocalMessageMapper>().mapToListEntity(localMessages);
  }

  Future<void> upsertMessage(Message message) {
    final localMessage = getIt<LocalMessageMapper>().mapToData(message);
    return _db.messageDao.upsertMessage(localMessage);
  }

  Future<List<Session>> findAllSessions() async {
    final localSessions = await _db.sessionDao.findAllSessions();
    return getIt<LocalSessionMapper>().mapToListEntity(localSessions);
  }

  Future<Session?> findSessionById(int id) async {
    final localSession = await _db.sessionDao.findSessionById(id);
    if (localSession == null) {
      return null;
    }
    return getIt<LocalSessionMapper>().mapToEntity(localSession);
  }

  Future<Session> upsertSession(Session session) async {
    final localSession = getIt<LocalSessionMapper>().mapToData(session);
    await _db.sessionDao.upsertSession(localSession);
    return session;
  }

  Future<Session?> findLastSession() async {
    final localSession = await _db.sessionDao.findLastSession();
    if (localSession == null) {
      return null;
    }
    return getIt<LocalSessionMapper>().mapToEntity(localSession);
  }

  Future<void> deleteSession(Session session) async {
    await _db.sessionDao
        .deleteSession(getIt<LocalSessionMapper>().mapToData(session));
  }
}
