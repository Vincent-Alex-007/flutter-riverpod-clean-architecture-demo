// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get counter_demo_title => '计数器';

  @override
  String get counter_demo_description => '这是一个计数器描述。';

  @override
  String get counter_demo_button_text => '增加';
}

/// The translations for Chinese, as used in China, using the Han script (`zh_Hans_CN`).
class L10nZhHansCn extends L10nZh {
  L10nZhHansCn() : super('zh_Hans_CN');
}
