import 'dart:async';

import 'package:floor/floor.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import 'converter/datetime_converter.dart';
import 'dao/message_dao.dart';
import 'dao/session_dao.dart';
import 'model/local_message.dart';
import 'model/local_session.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [LocalMessage, LocalSession])
@TypeConverters([DatetimeConverter])
abstract class AppDatabase extends FloorDatabase {
  MessageDao get messageDao;

  SessionDao get sessionDao;
}
