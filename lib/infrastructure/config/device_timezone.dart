import 'package:flutter_timezone/flutter_timezone.dart' show FlutterTimezone;
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest_all.dart' show initializeTimeZones;
import 'package:timezone/timezone.dart' show local, timeZoneDatabase;

/// resolve device timezone
@singleton
final class DeviceTimezone {
  String? name;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    initializeTimeZones();

    try {
      final info = await FlutterTimezone.getLocalTimezone();
      if (timeZoneDatabase.locations.containsKey(info.identifier)) {
        name = info.identifier;
        return;
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
