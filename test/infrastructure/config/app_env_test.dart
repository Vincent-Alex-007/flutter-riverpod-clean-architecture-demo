import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_template/core/enums/app_env_enum.dart';
import 'package:riverpod_template/infrastructure/config/app_env.dart';
import 'package:riverpod_template/infrastructure/di/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    const channel = MethodChannel('flutter_timezone');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          switch (call.method) {
            case 'getLocalTimezone':
              return 'UTC';
            default:
              return null;
          }
        });
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('AppEnv getIt', () {
    test('dev 环境 resolve 为 AppEnvDev', () async {
      await configureDependencies(AppEnvEnum.dev.value);

      final appEnv = getIt<AppEnv>();

      expect(appEnv, isA<AppEnvDev>());
      expect(appEnv.env, AppEnvEnum.dev);
      expect(appEnv.baseUrl, 'https://api.dev.example.com');
    });

    test('uat 环境 resolve 为 AppEnvUat', () async {
      await configureDependencies(AppEnvEnum.uat.value);

      final appEnv = getIt<AppEnv>();

      expect(appEnv, isA<AppEnvUat>());
      expect(appEnv.env, AppEnvEnum.uat);
      expect(appEnv.baseUrl, 'https://api.uat.example.com');
    });

    test('prod 环境 resolve 为 AppEnvProd', () async {
      await configureDependencies(AppEnvEnum.prod.value);

      final appEnv = getIt<AppEnv>();

      expect(appEnv, isA<AppEnvProd>());
      expect(appEnv.env, AppEnvEnum.prod);
      expect(appEnv.baseUrl, 'https://api.prod.example.com');
    });
  });

  group('AppEnv baseUrl', () {
    test('dev 环境输出 dev baseUrl', () {
      final appEnv = AppEnvDev();

      expect(appEnv.baseUrl, 'https://api.dev.example.com');
    });

    test('uat 环境输出 uat baseUrl', () async {
      final appEnv = AppEnvUat();

      expect(appEnv.baseUrl, 'https://api.uat.example.com');
    });

    test('prod 环境输出 prod baseUrl', () async {
      final appEnv = AppEnvProd();

      expect(appEnv.baseUrl, 'https://api.prod.example.com');
    });
  });
}
