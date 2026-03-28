// core/time/time_zone_store.dart
import 'dart:async';

import 'package:flutter_timezone/flutter_timezone.dart' as ftz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

// TODO(username): message.
final class TimeZoneConfig {
  TimeZoneConfig._();

  static final TimeZoneConfig instance = TimeZoneConfig._();

  late tz.Location _location;
  String _name = 'UTC';
  bool _initialized = false;

  String get currentName => _name;

  tz.Location get location => _location;

  /// 初始化：加载时区库，默认取设备时区（可自定义 resolver），失败兜底 UTC
  Future<void> init({
    String? timeZoneName,
    Future<String?> Function()? deviceTimeZoneResolver,
  }) async {
    if (_initialized) return;
    tzdata.initializeTimeZones();

    String name = timeZoneName ?? tz.local.name;
    try {
      if (deviceTimeZoneResolver != null) {
        final v = await deviceTimeZoneResolver();
        if (v != null && v.isNotEmpty) name = v; // 如 'Asia/Shanghai'
      }
      _location = tz.getLocation(name);
      _name = name;
    } catch (_) {
      final dateTimeNowZoneName = DateTime.now().timeZoneName;
      _location = tz.getLocation(dateTimeNowZoneName);
      _name = dateTimeNowZoneName;
    }

    tz.setLocalLocation(_location);
    _initialized = true;
  }

  /// 切换当前展示时区（IANA 名称）
  void setTimeZone(String name) {
    try {
      _location = tz.getLocation(name);
      _name = name;
      tz.setLocalLocation(_location);
    } catch (e) {
      rethrow;
    }
  }
}

Future<String?> resolveDeviceTimeZone() async {
  try {
    // 插件获取设备时区（期望返回 IANA，如 Asia/Shanghai）
    final name = await ftz.FlutterTimezone.getLocalTimezone();

    if (tz.timeZoneDatabase.locations.containsKey(name.identifier)) {
      return name.identifier;
    }
  } catch (_) {}

  // 兜底：tz.local 的名称（可能已是 IANA）
  try {
    final localName = tz.local.name;
    if (tz.timeZoneDatabase.locations.containsKey(localName)) {
      return localName;
    }
  } catch (_) {}

  return 'UTC';
}
