import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'infrastructure/di/injection.dart';
import 'l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: getIt<GoRouter>(),
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      supportedLocales: L10n.supportedLocales,
    );
  }
}
