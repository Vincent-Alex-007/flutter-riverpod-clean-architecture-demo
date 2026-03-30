import 'package:flutter_timezone/flutter_timezone.dart' show FlutterTimezone;
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' show local, timeZoneDatabase;

/// resolve device timezone
@singleton
final class DeviceTimezone {
  String? name;
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      if (timeZoneDatabase.locations.containsKey(info.identifier)) {
        name = info.identifier;
      }
    } catch (_) {}

    try {
      final localName = local.name;

      if (timeZoneDatabase.locations.containsKey(localName)) {
        name = localName;
      }
    } catch (_) {}
  }
}
