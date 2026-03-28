import 'package:envied/envied.dart';
import 'package:injectable/injectable.dart';

part 'app_env.g.dart';

enum AppEnvEnum {
  dev(value: 'dev', fileName: '.env.dev'),
  prod(value: 'prod', fileName: '.env.prod'),
  uat(value: 'uat', fileName: '.env.uat');

  const AppEnvEnum({required this.value, required this.fileName});

  final String value;
  final String fileName;
}

abstract interface class AppEnv {
  String get baseUrl;

  AppEnvEnum get env;
}

@lazySingleton
@Environment('dev')
@Envied(path: '.env.dev', allowOptionalFields: true)
final class AppEnvDev implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static const String _baseUrl = _AppEnvDev._baseUrl;

  @override
  String get baseUrl => _baseUrl;

  @override
  AppEnvEnum get env => AppEnvEnum.dev;
}

@lazySingleton
@Environment('prod')
@Envied(path: '.env.prod', obfuscate: true, allowOptionalFields: true)
final class AppEnvProd implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static final String _baseUrl = _AppEnvProd._baseUrl;

  @override
  String get baseUrl => _baseUrl;

  @override
  AppEnvEnum get env => AppEnvEnum.prod;
}

@lazySingleton
@Environment('uat')
@Envied(path: '.env.uat', allowOptionalFields: true)
final class AppEnvUat implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static const String _baseUrl = _AppEnvUat._baseUrl;

  @override
  String get baseUrl => _baseUrl;

  @override
  AppEnvEnum get env => AppEnvEnum.uat;
}
