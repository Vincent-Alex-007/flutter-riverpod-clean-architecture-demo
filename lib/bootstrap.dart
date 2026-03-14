import 'dart:async';

import 'package:flutter/widgets.dart';

/// 启动应用程序
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // 运行应用程序
  runZonedGuarded(
    () async => runApp(await builder()),
    (error, stack) => print(error),
  );
}
