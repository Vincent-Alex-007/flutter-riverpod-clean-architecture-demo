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
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

import '../../features/counter/application/get_counter.dart' as _i394;
import '../../features/counter/application/increment_counter.dart' as _i43;
import '../../features/counter/domain/counter_local_data_source.dart' as _i234;
import '../../features/counter/domain/counter_remote_data_source.dart' as _i733;
import '../../features/counter/domain/counter_repository.dart' as _i1059;
import '../../features/counter/infrastructure/counter_local_data_source_impl.dart'
    as _i243;
import '../../features/counter/infrastructure/counter_remote_data_source_impl.dart'
    as _i375;
import '../../features/counter/infrastructure/counter_repository_impl.dart'
    as _i1047;
import '../config/app_env.dart' as _i979;
import '../config/device_timezone.dart' as _i267;
import '../config/timezone.dart' as _i641;
import '../errors/error_handler.dart' as _i433;
import '../network/dio_client.dart' as _i667;
import '../network/interceptors/auth_interceptor.dart' as _i745;
import '../network/interceptors/response_interceptor.dart' as _i292;
import 'modules/log_module.dart' as _i417;
import 'modules/router_module.dart' as _i322;
import 'modules/storage_module.dart' as _i148;

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
    await gh.singletonAsync<_i267.DeviceTimezone>(() {
      final i = _i267.DeviceTimezone();
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.singleton<_i207.Talker>(() => logModule.talker);
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => storageModule.sharedPreference,
      preResolve: true,
    );
    gh.singleton<_i558.FlutterSecureStorage>(() => storageModule.secureStorage);
    gh.lazySingleton<_i433.ErrorHandler>(() => _i433.ErrorHandler());
    gh.lazySingleton<_i733.CounterRemoteDataSource>(
      () => _i375.CounterRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i979.AppEnvDev>(
      () => _i979.AppEnvDev(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i583.GoRouter>(
      () => routerModule.appRouter(gh<_i207.Talker>()),
    );
    gh.lazySingleton<_i292.ResponseInterceptor>(
      () => _i292.ResponseInterceptor(gh<_i433.ErrorHandler>()),
    );
    gh.singleton<_i641.Timezone>(
      () => _i641.Timezone(gh<_i267.DeviceTimezone>()),
    );
    gh.lazySingleton<_i667.DioClient>(
      () => _i667.DioClient(
        gh<_i207.Talker>(),
        gh<_i292.ResponseInterceptor>(),
        gh<_i979.AppEnv>(),
      ),
    );
    gh.lazySingleton<_i979.AppEnvUat>(
      () => _i979.AppEnvUat(),
      registerFor: {_uat},
    );
    gh.lazySingleton<_i979.AppEnvProd>(
      () => _i979.AppEnvProd(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i234.CounterLocalDataSource>(
      () => _i243.CounterLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i745.AuthInterceptor>(
      () => _i745.AuthInterceptor(gh<_i667.DioClient>(), gh<_i979.AppEnv>()),
    );
    gh.lazySingleton<_i1059.CounterRepository>(
      () => _i1047.CounterRepositoryImpl(
        gh<_i733.CounterRemoteDataSource>(),
        gh<_i234.CounterLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i394.GetCounter>(
      () => _i394.GetCounter(gh<_i1059.CounterRepository>()),
    );
    gh.lazySingleton<_i43.IncrementCounter>(
      () => _i43.IncrementCounter(gh<_i1059.CounterRepository>()),
    );
    return this;
  }
}

class _$LogModule extends _i417.LogModule {}

class _$StorageModule extends _i148.StorageModule {}

class _$RouterModule extends _i322.RouterModule {}
