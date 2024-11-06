import 'package:floor/floor.dart';

@Entity(tableName: 'messages')
class LocalMessage {
  @primaryKey
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  @ForeignKey(
      childColumns: ['session_id'], parentColumns: ['id'], entity: LocalMessage)
  @ColumnInfo(name: 'session_id')
  final String sessionId;

  const LocalMessage(
      {required this.id,
      required this.content,
      required this.isUser,
      required this.timestamp,
      required this.sessionId});
}
