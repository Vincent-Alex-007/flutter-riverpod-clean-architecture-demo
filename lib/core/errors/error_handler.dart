import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'exceptions.dart';

enum NetworkExceptionMessageEnum {
  connectionTimeout('CONNECTION_TIMEOUT'),
  serverRequestFailed('REQUEST_FAILED'),
  requestCancelled('REQUEST_CANCELLED'),
  networkConnectionError('CONNECTION_ERROR'),
  unknownNetworkError('UNKNOWN_ERROR');

  const NetworkExceptionMessageEnum(this.message);
  final String message;
}

/// error handler
@lazySingleton
final class ErrorHandler {
  AppException handle(Object error, {StackTrace? stackTrace}) {
    String errorMessage = 'Unknown error: $error';
    StackTrace? stackTrace0 = stackTrace;

    //create a network error fallback
    AppException<Object?> appException = AppException(
      message: errorMessage,
      code: -1,
      error: error,
      stackTrace: stackTrace0,
    );

    //if the error is a business exception, return it directly (BusinessException and JsonException are subclasses of AppException)
    if (error is AppException) {
      if (error is BusinessException) {
        errorMessage = 'BusinessException: $error';
      } else if (error is JsonException) {
        errorMessage = 'JsonException: $error';
      } else if (error is NetworkException) {
        errorMessage = 'NetworkException: $error';
      } else {
        errorMessage = 'AppException: $error';
      }
      appException = error;
      stackTrace0 ??= error.stackTrace;
    }

    //if the error is a DioException, handle it as a network error
    if (error is DioException) {
      final ex = _handleDioException(error);

      errorMessage = 'DioException mapped to $ex';
      appException = ex;
      stackTrace0 ??= error.stackTrace;
    }

    //if the error is a FormatException or TypeError, handle it as a json error
    if (error is FormatException || error is TypeError) {
      final ex = JsonException(
        message: 'Data parsing error',
        code: -1,
        error: error,
        stackTrace: stackTrace0,
      );

      errorMessage = 'JsonException: $error';
      appException = ex;
    }

    return appException;
  }

  NetworkException _handleDioException(DioException error) {
    int? code = error.response?.statusCode;
    String? message = error.message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = NetworkExceptionMessageEnum.connectionTimeout.message;
        code = 408;
        break;
      case DioExceptionType.badResponse:
        message = NetworkExceptionMessageEnum.serverRequestFailed.message;
        break;
      case DioExceptionType.cancel:
        message = NetworkExceptionMessageEnum.requestCancelled.message;
        break;
      case DioExceptionType.connectionError:
        message = NetworkExceptionMessageEnum.networkConnectionError.message;
        break;
      default:
        message = NetworkExceptionMessageEnum.unknownNetworkError.message;
        break;
    }

    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final dataCode = data['code'] as int?;
      final dataMessage = data['message'] as String?;
      if (dataCode != null && dataCode.toString().isNotEmpty) {
        code = dataCode;
      }
      if (dataMessage != null && dataMessage.isNotEmpty) {
        message = dataMessage;
      }
    }

    return NetworkException(
      message: message,
      code: code,
      error: error,
      stackTrace: error.stackTrace,
    );
  }
}
