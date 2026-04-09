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
import '../../features/order/data/datasources/cart_local_data_source.dart'
    as _i7;
import '../../features/order/data/datasources/cart_local_data_source_impl.dart'
    as _i180;
import '../../features/order/data/datasources/order_local_data_source.dart'
    as _i1064;
import '../../features/order/data/datasources/order_local_data_source_impl.dart'
    as _i992;
import '../../features/order/data/repositories/cart_repository_impl.dart'
    as _i188;
import '../../features/order/data/repositories/order_repository_impl.dart'
    as _i103;
import '../../features/order/domain/repositories/cart_repository.dart' as _i37;
import '../../features/order/domain/repositories/order_repository.dart'
    as _i765;
import '../../features/order/domain/services/pricing_service.dart' as _i157;
import '../../features/order/domain/usecases/add_to_cart.dart' as _i633;
import '../../features/order/domain/usecases/get_cart.dart' as _i251;
import '../../features/order/domain/usecases/preview_order.dart' as _i574;
import '../../features/order/domain/usecases/remove_from_cart.dart' as _i1008;
import '../../features/order/domain/usecases/submit_order.dart' as _i182;
import '../../features/product/data/datasources/product_local_data_source.dart'
    as _i814;
import '../../features/product/data/datasources/product_local_data_source_impl.dart'
    as _i358;
import '../../features/product/data/repositories/product_repository_impl.dart'
    as _i1040;
import '../../features/product/domain/repositories/product_repository.dart'
    as _i39;
import '../../features/product/domain/usecases/get_products.dart' as _i279;
import '../../features/todo/data/datasources/todo_local_data_source.dart'
    as _i471;
import '../../features/todo/data/datasources/todo_local_data_source_impl.dart'
    as _i622;
import '../../features/todo/data/repositories/todo_repository_impl.dart'
    as _i767;
import '../../features/todo/domain/repositories/todo_repository.dart' as _i136;
import '../../features/todo/domain/usecases/add_todo.dart' as _i100;
import '../../features/todo/domain/usecases/delete_todo.dart' as _i48;
import '../../features/todo/domain/usecases/get_todos.dart' as _i997;
import '../../features/todo/domain/usecases/toggle_todo.dart' as _i346;
import '../config/app_env.dart' as _i979;
import '../config/device_timezone.dart' as _i267;
import '../config/timezone.dart' as _i641;
import '../database/app_database.dart' as _i982;
import '../errors/error_handler.dart' as _i433;
import '../network/dio_client.dart' as _i667;
import '../network/interceptors/auth_interceptor.dart' as _i745;
import '../network/interceptors/response_interceptor.dart' as _i292;
import '../websocket/websocket_client.dart' as _i275;
import 'modules/log_module.dart' as _i417;
import 'modules/router_module.dart' as _i322;
import 'modules/storage_module.dart' as _i148;

const String _uat = 'uat';
const String _dev = 'dev';
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
    gh.lazySingleton<_i157.PricingService>(() => _i157.PricingService());
    gh.lazySingleton<_i982.AppDatabase>(
      () => _i982.AppDatabase(),
      dispose: (i) => i.closeDatabase(),
    );
    gh.lazySingleton<_i433.ErrorHandler>(() => _i433.ErrorHandler());
    gh.lazySingleton<_i7.CartLocalDataSource>(
      () => _i180.CartLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i814.ProductLocalDataSource>(
      () => _i358.ProductLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i1030.CounterRemoteDataSource>(
      () => _i721.CounterRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i979.AppEnv>(
      () => _i979.AppEnvUat(),
      registerFor: {_uat},
    );
    gh.lazySingleton<_i471.TodoLocalDataSource>(
      () => _i622.TodoLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i583.GoRouter>(
      () => routerModule.appRouter(gh<_i207.Talker>()),
    );
    gh.lazySingleton<_i292.ResponseInterceptor>(
      () => _i292.ResponseInterceptor(gh<_i433.ErrorHandler>()),
    );
    gh.lazySingleton<_i979.AppEnv>(
      () => _i979.AppEnvDev(),
      registerFor: {_dev},
    );
    gh.singleton<_i641.Timezone>(
      () => _i641.Timezone(gh<_i267.DeviceTimezone>()),
    );
    gh.lazySingleton<_i1064.OrderLocalDataSource>(
      () => _i992.OrderLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i765.OrderRepository>(
      () => _i103.OrderRepositoryImpl(gh<_i1064.OrderLocalDataSource>()),
    );
    gh.lazySingleton<_i37.CartRepository>(
      () => _i188.CartRepositoryImpl(gh<_i7.CartLocalDataSource>()),
    );
    gh.lazySingleton<_i574.PreviewOrder>(
      () => _i574.PreviewOrder(
        gh<_i37.CartRepository>(),
        gh<_i157.PricingService>(),
      ),
    );
    gh.lazySingleton<_i39.ProductRepository>(
      () => _i1040.ProductRepositoryImpl(gh<_i814.ProductLocalDataSource>()),
    );
    gh.lazySingleton<_i979.AppEnv>(
      () => _i979.AppEnvProd(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i136.TodoRepository>(
      () => _i767.TodoRepositoryImpl(gh<_i471.TodoLocalDataSource>()),
    );
    gh.lazySingleton<_i275.WebSocketClient>(
      () => _i275.WebSocketClient(gh<_i207.Talker>(), gh<_i979.AppEnv>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i976.CounterLocalDataSource>(
      () => _i155.CounterLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i514.CounterRepository>(
      () => _i770.CounterRepositoryImpl(
        gh<_i1030.CounterRemoteDataSource>(),
        gh<_i976.CounterLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i182.SubmitOrder>(
      () => _i182.SubmitOrder(
        gh<_i37.CartRepository>(),
        gh<_i765.OrderRepository>(),
        gh<_i39.ProductRepository>(),
        gh<_i157.PricingService>(),
      ),
    );
    gh.lazySingleton<_i633.AddToCart>(
      () => _i633.AddToCart(gh<_i37.CartRepository>()),
    );
    gh.lazySingleton<_i251.GetCart>(
      () => _i251.GetCart(gh<_i37.CartRepository>()),
    );
    gh.lazySingleton<_i1008.RemoveFromCart>(
      () => _i1008.RemoveFromCart(gh<_i37.CartRepository>()),
    );
    gh.lazySingleton<_i667.DioClient>(
      () => _i667.DioClient(
        gh<_i207.Talker>(),
        gh<_i292.ResponseInterceptor>(),
        gh<_i979.AppEnv>(),
      ),
    );
    gh.lazySingleton<_i279.GetProducts>(
      () => _i279.GetProducts(gh<_i39.ProductRepository>()),
    );
    gh.lazySingleton<_i100.AddTodo>(
      () => _i100.AddTodo(gh<_i136.TodoRepository>()),
    );
    gh.lazySingleton<_i48.DeleteTodo>(
      () => _i48.DeleteTodo(gh<_i136.TodoRepository>()),
    );
    gh.lazySingleton<_i997.GetTodos>(
      () => _i997.GetTodos(gh<_i136.TodoRepository>()),
    );
    gh.lazySingleton<_i346.ToggleTodo>(
      () => _i346.ToggleTodo(gh<_i136.TodoRepository>()),
    );
    gh.lazySingleton<_i245.GetCounter>(
      () => _i245.GetCounter(gh<_i514.CounterRepository>()),
    );
    gh.lazySingleton<_i931.IncrementCounter>(
      () => _i931.IncrementCounter(gh<_i514.CounterRepository>()),
    );
    gh.lazySingleton<_i745.AuthInterceptor>(
      () => _i745.AuthInterceptor(gh<_i667.DioClient>(), gh<_i979.AppEnv>()),
    );
    return this;
  }
}

class _$LogModule extends _i417.LogModule {}

class _$StorageModule extends _i148.StorageModule {}

class _$RouterModule extends _i322.RouterModule {}
