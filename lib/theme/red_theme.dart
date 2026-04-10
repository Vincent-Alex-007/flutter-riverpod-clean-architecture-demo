part of 'theme.dart';

abstract final class RedTheme {
  /// 种子色
  static const redSeed = Color(0xFFD32F2F);

  /// 红色浅色主题
  static ThemeData get light => buildTheme(Brightness.light, redSeed);

  /// 红色深色主题
  static ThemeData get dark => buildTheme(Brightness.dark, redSeed);
}
