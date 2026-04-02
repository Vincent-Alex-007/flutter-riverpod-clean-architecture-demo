// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class L10nKo extends L10n {
  L10nKo([String locale = 'ko']) : super(locale);

  @override
  String get counter_demo_title => '카운터';

  @override
  String get counter_demo_description => '이것은 카운터 설명입니다.';

  @override
  String get counter_demo_button_text => '증가';
}
