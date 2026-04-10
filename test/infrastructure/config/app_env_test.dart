import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_template/infrastructure/config/app_env.dart';

void main() {
  tearDown(() async {
    // await getIt.reset();
  });

  group('AppEnv baseUrl', () {
    test('dev 环境输出 dev baseUrl', () {
      // await configureDependencies('dev');
      final appEnv = AppEnv();

      expect(appEnv.baseUrl, 'https://api.dev.example.com');
    });

    test('uat 环境输出 uat baseUrl', () async {
      final appEnv = AppEnv();

      expect(appEnv.baseUrl, 'https://api.uat.example.com');
    });

    test('prod 环境输出 prod baseUrl', () async {
      final appEnv = AppEnv();

      expect(appEnv.baseUrl, 'https://api.prod.example.com');
    });
  });
}
