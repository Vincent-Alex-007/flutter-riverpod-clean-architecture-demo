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
import 'package:riverpod_template/infrastructure/config/app_env.dart' as _i352;
import 'package:riverpod_template/infrastructure/di/modules/log_module.dart'
    as _i1028;
import 'package:riverpod_template/infrastructure/di/modules/router_module.dart'
    as _i392;
import 'package:riverpod_template/infrastructure/di/modules/storage_module.dart'
    as _i425;
import 'package:riverpod_template/infrastructure/errors/error_handler.dart'
    as _i905;
import 'package:riverpod_template/infrastructure/network/dio_client.dart'
    as _i222;
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
    gh.lazySingleton<_i905.ErrorHandler>(() => _i905.ErrorHandler());
    gh.lazySingleton<_i222.DioClient>(
      () => _i222.DioClient(gh<_i207.Talker>(), gh<_i905.ErrorHandler>()),
    );
    gh.lazySingleton<_i352.AppEnvDev>(
      () => _i352.AppEnvDev(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i352.AppEnvUat>(
      () => _i352.AppEnvUat(),
      registerFor: {_uat},
    );
    gh.lazySingleton<_i352.AppEnvProd>(
      () => _i352.AppEnvProd(),
      registerFor: {_prod},
    );
    return this;
  }
}

class _$LogModule extends _i1028.LogModule {}

class _$StorageModule extends _i425.StorageModule {}

class _$RouterModule extends _i392.RouterModule {}
