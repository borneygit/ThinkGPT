import 'package:domain/domain.dart';
import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

extension SessionX on Session {
  static Session createSession(String title, String model) {
    final now = DateTime.now();
    final session = Session(
        id: getIt<Uuid>().v4(),
        title: title,
        model: model,
        type: 0,
        createdAt: now,
        updatedAt: now);
    return session;
  }
}
