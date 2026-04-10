part of 'theme.dart';

abstract final class BlueTheme {
  /// 种子色
  static const blueSeed = Color(0xFF1A73E8);

  /// 蓝色浅色主题
  static ThemeData get light => buildTheme(Brightness.light, blueSeed);

  /// 蓝色深色主题
  static ThemeData get dark => buildTheme(Brightness.dark, blueSeed);
}
