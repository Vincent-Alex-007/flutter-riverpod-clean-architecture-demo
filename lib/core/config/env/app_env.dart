import 'package:envied/envied.dart';

part 'app_env.g.dart';

late final AppEnv appEnv;

abstract interface class AppEnv {
  String get baseUrl;
}

@Envied(path: '.env.dev', allowOptionalFields: true)
final class AppEnvDev implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static const String _baseUrl = _AppEnvDev._baseUrl;

  @override
  String get baseUrl => _baseUrl;
}

@Envied(path: '.env.prod', obfuscate: true, allowOptionalFields: true)
final class AppEnvProd implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static final String _baseUrl = _AppEnvProd._baseUrl;

  @override
  String get baseUrl => _baseUrl;
}
