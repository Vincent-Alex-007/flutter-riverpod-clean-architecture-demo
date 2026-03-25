import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../config/env/app_env.dart';
import 'interceptors/response_model_interceptor.dart';

const String kContentTypeJson = 'application/json';

@lazySingleton
final class DioClient {
  DioClient(Talker talker) {
    _dio = Dio(
      BaseOptions(
        baseUrl: appEnv.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': kContentTypeJson, 'Accept': kContentTypeJson},
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors
      ..add(TalkerDioLogger(talker: talker))
      ..add(RetryInterceptor(dio: _dio))
      ..add(ResponseModelInterceptor());
  }

  late final Dio _dio;

  Dio get instance => _dio;
}
