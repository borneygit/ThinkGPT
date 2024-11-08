import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

part 'message.g.dart';

@freezed
class Message with _$Message {
  factory Message(
      {required String id,
      required String content,
      required bool isUser,
      required DateTime timestamp,
      required String sessionId}) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
