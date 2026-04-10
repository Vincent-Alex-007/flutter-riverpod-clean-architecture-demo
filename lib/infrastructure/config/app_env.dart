import 'package:envied/envied.dart';
import 'package:injectable/injectable.dart';

import '../../core/enums/app_env_enum.dart';

part 'app_env.g.dart';

@Envied(path: '.env.dev', name: 'AppEnvDev', allowOptionalFields: true)
@Envied(path: '.env.uat', name: 'AppEnvUat', allowOptionalFields: true)
@Envied(
  path: '.env.prod',
  name: 'AppEnvProd',
  obfuscate: true,
  allowOptionalFields: true,
)
abstract interface class AppEnvBase {
  @EnviedField(varName: 'BASE_URL')
  final String baseUrl = '';

  @EnviedField(varName: 'WS_URL')
  final String wsUrl = '';
}

abstract interface class AppEnv implements AppEnvBase {
  AppEnvEnum get env;
}

@LazySingleton(as: AppEnv)
@Environment('dev')
final class AppEnvDev extends _AppEnvDev implements AppEnv {
  @override
  AppEnvEnum get env => AppEnvEnum.dev;
}

@LazySingleton(as: AppEnv)
@Environment('prod')
final class AppEnvProd extends _AppEnvProd implements AppEnv {
  @override
  AppEnvEnum get env => AppEnvEnum.prod;
}

@LazySingleton(as: AppEnv)
@Environment('uat')
final class AppEnvUat extends _AppEnvUat implements AppEnv {
  @override
  AppEnvEnum get env => AppEnvEnum.uat;
}
