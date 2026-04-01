import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../router/app_router.dart';

@module
abstract class RouterModule {
  @lazySingleton
  GoRouter appRouter(Talker talker) => createAppRouter(talker);
}
