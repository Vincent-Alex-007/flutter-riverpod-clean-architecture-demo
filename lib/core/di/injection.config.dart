// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;
import 'package:riverpod_template/core/config/app_env.dart' as _i754;
import 'package:riverpod_template/core/di/modules/log_module.dart' as _i353;
import 'package:riverpod_template/core/di/modules/router_module.dart' as _i244;
import 'package:riverpod_template/core/di/modules/storage_module.dart' as _i61;
import 'package:riverpod_template/core/errors/error_handler.dart' as _i404;
import 'package:riverpod_template/core/network/dio_client.dart' as _i289;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

const String _dev = 'dev';
const String _uat = 'uat';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final logModule = _$LogModule();
    final storageModule = _$StorageModule();
    final routerModule = _$RouterModule();
    gh.singleton<_i207.Talker>(() => logModule.talker);
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => storageModule.sharedPreference,
      preResolve: true,
    );
    gh.singleton<_i558.FlutterSecureStorage>(() => storageModule.secureStorage);
    gh.lazySingleton<_i583.GoRouter>(() => routerModule.appRouter);
    gh.lazySingleton<_i404.ErrorHandler>(() => _i404.ErrorHandler());
    gh.lazySingleton<_i754.AppEnvDev>(
      () => _i754.AppEnvDev(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i754.AppEnvUat>(
      () => _i754.AppEnvUat(),
      registerFor: {_uat},
    );
    gh.lazySingleton<_i754.AppEnvProd>(
      () => _i754.AppEnvProd(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i289.DioClient>(
      () => _i289.DioClient(gh<_i207.Talker>(), gh<_i404.ErrorHandler>()),
    );
    return this;
  }
}

class _$LogModule extends _i353.LogModule {}

class _$StorageModule extends _i61.StorageModule {}

class _$RouterModule extends _i244.RouterModule {}
