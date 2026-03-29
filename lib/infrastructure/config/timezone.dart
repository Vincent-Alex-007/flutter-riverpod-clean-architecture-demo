import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest_all.dart' show initializeTimeZones;
import 'package:timezone/timezone.dart'
    show Location, UTC, getLocation, setLocalLocation;

import 'device_timezone.dart';

@singleton
final class Timezone {
  Timezone(this._deviceTimezone) {
    initializeTimeZones();

    String? ianaName = _deviceTimezone.name?.trim();

    final loc = _locationForIana(ianaName);
    location = loc;
    name = loc.name;
    setLocalLocation(location);
  }

  final DeviceTimezone _deviceTimezone;

  Location location = UTC;

  String name = 'UTC';

  static Location _locationForIana(String? ianaName) {
    final key = ianaName?.trim();
    if (key == null || key.isEmpty) return UTC;
    try {
      return getLocation(key);
    } catch (_) {
      return UTC;
    }
  }

  void setTimeZone(String name) {
    final loc = _locationForIana(name);
    location = loc;
    name = loc.name;
    setLocalLocation(location);
  }
}
