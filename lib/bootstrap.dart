import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

import 'core/di/injection.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // 确保 Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

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
