import 'package:envied/envied.dart';

part 'app_env.g.dart';

late final AppEnv appEnv;

enum AppEnvEnum {
  dev(value: 'dev', filename: '.env.dev'),

  prod(value: 'prod', filename: '.env.prod');

  const AppEnvEnum({required this.value, required this.filename});

  final String value;

  final String filename;
}

abstract interface class AppEnv {
  String get baseUrl;

  AppEnvEnum get env;
}

@Envied(path: '.env.dev', allowOptionalFields: true)
final class AppEnvDev implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static const String _baseUrl = _AppEnvDev._baseUrl;

  @override
  String get baseUrl => _baseUrl;

  @override
  AppEnvEnum get env => AppEnvEnum.dev;
}

@Envied(path: '.env.prod', obfuscate: true, allowOptionalFields: true)
final class AppEnvProd implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static final String _baseUrl = _AppEnvProd._baseUrl;

  @override
  String get baseUrl => _baseUrl;

  @override
  AppEnvEnum get env => AppEnvEnum.prod;
}
