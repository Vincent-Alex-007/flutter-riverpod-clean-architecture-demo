import 'package:envied/envied.dart';
import 'package:injectable/injectable.dart';

import '../../core/enums/app_env_enum.dart';

part 'app_env.g.dart';

abstract interface class AppEnv {
  String get baseUrl;

  String get wsUrl;

  AppEnvEnum get env;
}

@LazySingleton(as: AppEnv)
@Environment('dev')
@Envied(path: '.env.dev', allowOptionalFields: true)
final class AppEnvDev implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static const String _baseUrl = _AppEnvDev._baseUrl;

  @EnviedField(varName: 'WS_URL')
  static const String _wsUrl = _AppEnvDev._wsUrl;

  @override
  String get baseUrl => _baseUrl;

  @override
  String get wsUrl => _wsUrl;

  @override
  AppEnvEnum get env => AppEnvEnum.dev;
}

@LazySingleton(as: AppEnv)
@Environment('prod')
@Envied(path: '.env.prod', obfuscate: true, allowOptionalFields: true)
final class AppEnvProd implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static final String _baseUrl = _AppEnvProd._baseUrl;

  @EnviedField(varName: 'WS_URL', obfuscate: true)
  static final String _wsUrl = _AppEnvProd._wsUrl;

  @override
  String get baseUrl => _baseUrl;

  @override
  String get wsUrl => _wsUrl;

  @override
  AppEnvEnum get env => AppEnvEnum.prod;
}

@LazySingleton(as: AppEnv)
@Environment('uat')
@Envied(path: '.env.uat', allowOptionalFields: true)
final class AppEnvUat implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static const String _baseUrl = _AppEnvUat._baseUrl;

  @EnviedField(varName: 'WS_URL')
  static const String _wsUrl = _AppEnvUat._wsUrl;

  @override
  String get baseUrl => _baseUrl;

  @override
  String get wsUrl => _wsUrl;

  @override
  AppEnvEnum get env => AppEnvEnum.uat;
}
