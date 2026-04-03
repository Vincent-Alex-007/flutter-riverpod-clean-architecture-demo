// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class L10nEs extends L10n {
  L10nEs([String locale = 'es']) : super(locale);

  @override
  String get counter_demo_title => 'Contador';

  @override
  String get counter_demo_description => 'Este es un contador.';

  @override
  String get counter_demo_button_text => 'Incrementar';
}
