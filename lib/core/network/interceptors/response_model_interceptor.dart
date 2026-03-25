import 'package:dio/dio.dart';

import '../../errors/error_handler.dart';
import '../../errors/exceptions.dart';
import '../response_model.dart';

final class ResponseModelInterceptor extends Interceptor {
  ResponseModelInterceptor({required this.errorHandler});
  final ErrorHandler errorHandler;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    try {
      final responseModel = ResponseModel.fromJson(
        response.data,
        (json) => json,
      );

      // statusCode is 200 but the response is not successful
      if (!responseModel.isSuccess) {
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: BusinessException(
              message: responseModel.msg,
              code: responseModel.code,
            ),
            type: DioExceptionType.unknown,
          ),
        );
        return;
      }

      response.data = responseModel;

      handler.next(response);
    } catch (e, s) {
      // statusCode is 200 but the response is not successful
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: AppException(
            message: e.toString(),
            code: -1,
            error: e,
            stackTrace: s,
          ),
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 统一映射：把 DioException 中的 error => BusinessException / JsonException / NetworkException 其他异常都落成 AppException
    final mapped = errorHandler.handle(
      err.error ?? err,
      stackTrace: err.stackTrace,
    );
    handler.reject(
      err.copyWith(
        error: mapped,
        // 如果你希望 response 也带着（例如 4xx/5xx 的 body），保留 err.response
        // response: err.response,
      ),
    );
  }
}
