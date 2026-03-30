import 'dart:ui';

const Locale localeZh = Locale('zh');

const Locale localeZhCn = Locale('zh', 'CN');

const Locale localeZhHansCn = Locale.fromSubtags(
  languageCode: 'zh',
  countryCode: 'CN',
  scriptCode: 'Hans',
);

const Locale localeZhHans = Locale.fromSubtags(
  languageCode: 'zh',
  scriptCode: 'Hans',
);

const Locale localeEn = Locale('en');

const Locale localeEnUs = Locale('en', 'US');

const Locale localeUnkown = Locale.fromSubtags();
