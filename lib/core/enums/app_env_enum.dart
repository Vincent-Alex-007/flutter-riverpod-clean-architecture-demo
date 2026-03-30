enum AppEnvEnum {
  dev(value: 'dev', fileName: '.env.dev'),
  prod(value: 'prod', fileName: '.env.prod'),
  uat(value: 'uat', fileName: '.env.uat');

  const AppEnvEnum({required this.value, required this.fileName});

  final String value;
  final String fileName;
}
