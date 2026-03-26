import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

import 'core/config/app_env.dart'
    show AppEnvDev, AppEnvEnum, AppEnvProd, appEnv;
import 'core/di/injection.dart';

Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  required AppEnvEnum appEnvEnum,
}) async {
  // 确保 Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment variables
  switch (appEnvEnum) {
    case AppEnvEnum.dev:
      appEnv = AppEnvDev();
      break;
    case AppEnvEnum.prod:
      appEnv = AppEnvProd();
      break;
  }
  // Configure dependencies
  await configureDependencies();

  // Get the talker
  final talker = getIt<Talker>();

  final container = ProviderContainer(
    observers: [TalkerRiverpodObserver(talker: talker)],
  );

  // Run the application
  runZonedGuarded(
    () async => runApp(
      UncontrolledProviderScope(container: container, child: await builder()),
    ),
    (error, stack) => talker.handle(error),
  );
}
