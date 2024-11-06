import 'package:floor/floor.dart';

import '../model/local_session.dart';

@dao
abstract class SessionDao {
  @Query('SELECT * FROM sessions ORDER BY updatedAt DESC')
  Future<List<LocalSession>> findAllSessions();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> upsertSession(LocalSession session);

  @delete
  Future<void> deleteSession(LocalSession session);

  @Query('SELECT * FROM sessions ORDER BY updatedAt DESC LIMIT 1')
  Future<LocalSession?> findLastSession();

  @Query('SELECT * FROM sessions WHERE id = :id')
  Future<LocalSession?> findSessionById(int id);
}
