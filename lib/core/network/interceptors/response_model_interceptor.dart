import 'package:dio/dio.dart';

import '../../errors/exceptions.dart';
import '../response_model.dart';

class ResponseModelInterceptor extends Interceptor {
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
        final exception = BusinessException(
          message: responseModel.msg,
          code: responseModel.code,
        );

        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: exception,
            type: DioExceptionType.unknown,
          ),
        );
        return;
      }

      response.data = responseModel;

      handler.next(response);
    } on Exception catch (e, s) {
      // statusCode is 200 but the response is not successful
      final exception = AppException(
        message: e.toString(),
        code: -1,
        error: e,
        stackTrace: s,
      );

      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: exception,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
