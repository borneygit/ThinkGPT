import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';

part 'session.g.dart';

@freezed
class Session with _$Session {
  factory Session(
      {required String id,
      required String title,
      required String model,
      required int type,
      required DateTime createdAt,
      required DateTime updatedAt}) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
