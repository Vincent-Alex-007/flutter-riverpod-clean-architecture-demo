import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../config/app_env.dart';
import '../errors/error_handler.dart';
import '../errors/exceptions.dart';
import 'interceptors/response_model_interceptor.dart';

const String kContentTypeJson = 'application/json';

@lazySingleton
final class DioClient {
  DioClient(Talker talker, ErrorHandler errorHandler) {
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
      ..add(ResponseModelInterceptor(errorHandler: errorHandler))
      ..add(
        RetryInterceptor(
          dio: _dio,
          retries: 3,
          retryDelays: [
            const Duration(seconds: 1),
            const Duration(seconds: 2),
            const Duration(seconds: 4),
          ],
          ignoreRetryEvaluatorExceptions: false,
          retryEvaluator: (error, attempt) {
            final inner = error.error;
            if (inner is BusinessException || inner is JsonException) {
              return false;
            }

            if (error.type == DioExceptionType.cancel) {
              return false;
            }

            if (error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.sendTimeout ||
                error.type == DioExceptionType.connectionError) {
              return true;
            }

            final status = error.response?.statusCode;
            if (status == null) return false;

            const retryableStatuses = {408, 429, 500, 502, 503, 504};

            return retryableStatuses.contains(status);
          },
        ),
      )
      ..add(TalkerDioLogger(talker: talker));
  }
  late final Dio _dio;

  Dio get instance => _dio;
}
