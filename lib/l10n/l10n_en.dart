// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get counter_demo_title => 'Counter';

  @override
  String get counter_demo_description => 'This is a counter description.';

  @override
  String get counter_demo_button_text => 'Increment';
}

/// The translations for English, as used in the United States (`en_US`).
class L10nEnUs extends L10nEn {
  L10nEnUs() : super('en_US');

  @override
  String get counter_demo_title => 'Counter';

  @override
  String get counter_demo_description => 'This is a counter description.';
}
