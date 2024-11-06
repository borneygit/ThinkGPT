import 'package:domain/domain.dart';

import '../../base/base_data_mapper.dart';
import '../model/local_session.dart';

class LocalSessionMapper extends BaseDataMapper<LocalSession, Session>
    with DataMapperMixin {
  @override
  LocalSession mapToData(Session entity) {
    return LocalSession(
      id: entity.id,
      title: entity.title,
      model: entity.model,
      type: entity.type,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Session mapToEntity(LocalSession data) {
    return Session(
        id: data.id,
        title: data.title,
        model: data.model,
        type: data.type,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt);
  }
}
