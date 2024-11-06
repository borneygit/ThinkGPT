import 'package:data/src/repository/source/database/mapper/local_message_mapper.dart';
import 'package:data/src/repository/source/database/mapper/local_session_mapper.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class DataModule {
  @singleton
  @preResolve
  Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();

  LocalMessageMapper get localMessageMapper => LocalMessageMapper();

  LocalSessionMapper get localSessionMapper => LocalSessionMapper();
}
