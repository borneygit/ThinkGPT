import 'package:floor/floor.dart';

import '../model/local_message.dart';

@dao
abstract class MessageDao {
  @Query('SELECT * FROM messages')
  Future<List<LocalMessage>> findAllMessages();

  @Query('SELECT * FROM messages WHERE id = :id')
  Future<LocalMessage?> findMessageById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertMessage(LocalMessage message);

  @delete
  Future<void> deleteMessage(LocalMessage message);

  @Query('SELECT * FROM messages WHERE session_id = :sessionId')
  Future<List<LocalMessage>> findMessagesBySessionId(String sessionId);
}
