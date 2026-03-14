import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../di/injection.dart';
import '../errors/error_handler.dart';
import '../errors/exceptions.dart';
import 'response_model.dart';

const String kContentTypeJson = 'application/json';

@lazySingleton
class DioClient {
  DioClient(this._errorHandler) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': kContentTypeJson, 'Accept': kContentTypeJson},
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors
      ..add(TalkerDioLogger(talker: getIt<Talker>()))
      ..add(RetryInterceptor(dio: _dio));
  }

  late final Dio _dio;

  final ErrorHandler _errorHandler;

  // request wrapper
  Future<ResponseModel<T?>> _request<T>(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();

      final jsonData = response.data;

      final responseModel = ResponseModel.fromJson(jsonData, (json) {
        if (json is T) {
          return json;
        }
        throw JsonException(
          message: 'Expected type: $T, but got: ${json.runtimeType}',
        );
      });

      if (!responseModel.isSuccess) {
        throw BusinessException(
          message: responseModel.msg,
          code: responseModel.code,
        );
      }

      return responseModel;
    } catch (error, stackTrace) {
      throw _errorHandler.handle(error, stackTrace: stackTrace);
    }
  }

  /// GET request
  Future<ResponseModel<T?>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) => _request<T>(
    () => _dio.get(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    ),
  );

  /// POST request
  Future<ResponseModel<T?>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) => _request<T>(
    () => _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    ),
  );

  /// PUT request
  Future<ResponseModel<T?>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) => _request<T>(
    () => _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    ),
  );

  /// DELETE request
  Future<ResponseModel<T?>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _request<T>(
    () => _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    ),
  );

  Dio get dioInstance => _dio;
}
