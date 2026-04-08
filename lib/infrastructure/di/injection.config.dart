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

import '../../features/counter/data/datasources/counter_local_data_source.dart'
    as _i976;
import '../../features/counter/data/datasources/counter_local_data_source_impl.dart'
    as _i155;
import '../../features/counter/data/datasources/counter_remote_data_source.dart'
    as _i1030;
import '../../features/counter/data/datasources/counter_remote_data_source_impl.dart'
    as _i721;
import '../../features/counter/data/repositories/counter_repository_impl.dart'
    as _i770;
import '../../features/counter/domain/repositories/counter_repository.dart'
    as _i514;
import '../../features/counter/domain/usecases/get_counter.dart' as _i245;
import '../../features/counter/domain/usecases/increment_counter.dart' as _i931;
import '../config/app_env.dart' as _i979;
import '../config/device_timezone.dart' as _i267;
import '../config/timezone.dart' as _i641;
import '../errors/error_handler.dart' as _i433;
import '../services/network/dio_client.dart' as _i981;
import '../services/network/interceptors/auth_interceptor.dart' as _i304;
import '../services/network/interceptors/response_interceptor.dart' as _i92;
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
    gh.lazySingleton<_i1030.CounterRemoteDataSource>(
      () => _i721.CounterRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i979.AppEnvDev>(
      () => _i979.AppEnvDev(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i583.GoRouter>(
      () => routerModule.appRouter(gh<_i207.Talker>()),
    );
    gh.lazySingleton<_i92.ResponseInterceptor>(
      () => _i92.ResponseInterceptor(gh<_i433.ErrorHandler>()),
    );
    gh.singleton<_i641.Timezone>(
      () => _i641.Timezone(gh<_i267.DeviceTimezone>()),
    );
    gh.lazySingleton<_i979.AppEnvUat>(
      () => _i979.AppEnvUat(),
      registerFor: {_uat},
    );
    gh.lazySingleton<_i979.AppEnvProd>(
      () => _i979.AppEnvProd(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i981.DioClient>(
      () => _i981.DioClient(
        gh<_i207.Talker>(),
        gh<_i92.ResponseInterceptor>(),
        gh<_i979.AppEnv>(),
      ),
    );
    gh.lazySingleton<_i976.CounterLocalDataSource>(
      () => _i155.CounterLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i304.AuthInterceptor>(
      () => _i304.AuthInterceptor(gh<_i981.DioClient>(), gh<_i979.AppEnv>()),
    );
    gh.lazySingleton<_i514.CounterRepository>(
      () => _i770.CounterRepositoryImpl(
        gh<_i1030.CounterRemoteDataSource>(),
        gh<_i976.CounterLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i245.GetCounter>(
      () => _i245.GetCounter(gh<_i514.CounterRepository>()),
    );
    gh.lazySingleton<_i931.IncrementCounter>(
      () => _i931.IncrementCounter(gh<_i514.CounterRepository>()),
    );
    return this;
  }
}

class _$LogModule extends _i417.LogModule {}

class _$StorageModule extends _i148.StorageModule {}

class _$RouterModule extends _i322.RouterModule {}
