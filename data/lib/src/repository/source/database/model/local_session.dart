import 'package:floor/floor.dart';

@Entity(tableName: 'sessions')
class LocalSession {
  @primaryKey
  final String id;
  final String title;
  final String model;
  final int type;
  final DateTime createdAt;
  final DateTime updatedAt;

  LocalSession(
      {required this.id,
      required this.title,
      required this.model,
      required this.type,
      required this.createdAt,
      required this.updatedAt});
}
