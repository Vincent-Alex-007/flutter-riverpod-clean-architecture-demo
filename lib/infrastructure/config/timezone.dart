import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart'
    show Location, UTC, getLocation, setLocalLocation;

import 'device_timezone.dart';

@singleton
final class Timezone {
  Timezone(this._deviceTimezone) {
    final loc = _locationForIana(_deviceTimezone.name);
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

  void setTimeZone(String ianaName) {
    final loc = _locationForIana(ianaName);
    location = loc;
    name = loc.name;
    setLocalLocation(location);
  }
}
