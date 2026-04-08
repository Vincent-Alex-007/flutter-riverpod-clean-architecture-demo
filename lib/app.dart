import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'infrastructure/di/injection.dart';
import 'l10n/l10n.g.dart';

final class App extends HookWidget {
  App({super.key});

  final _router = getIt<GoRouter>();
  final _theme = ThemeData(primarySwatch: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: _theme,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: L10n.localizationsDelegates,
    );
  }
}
