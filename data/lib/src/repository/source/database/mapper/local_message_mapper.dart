import 'package:domain/domain.dart';

import '../../base/base_data_mapper.dart';
import '../model/local_message.dart';

class LocalMessageMapper extends BaseDataMapper<LocalMessage, Message>
    with DataMapperMixin {
  @override
  LocalMessage mapToData(Message entity) {
    return LocalMessage(
      id: entity.id,
      content: entity.content,
      isUser: entity.isUser,
      timestamp: entity.timestamp,
      sessionId: entity.sessionId,
    );
  }

  @override
  Message mapToEntity(LocalMessage data) {
    return Message(
      id: data.id,
      content: data.content,
      isUser: data.isUser,
      timestamp: data.timestamp,
      sessionId: data.sessionId,
    );
  }
}
