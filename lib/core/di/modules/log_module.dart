import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

@module
abstract class LogModule {
  @singleton
  Talker get talker => TalkerFlutter.init();
}
