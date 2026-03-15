import 'package:dio/dio.dart';

import '../response_model.dart';

class ResponseModelInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    try {
      final responseModel = ResponseModel.fromJson(response.data);

      if (!responseModel.isSuccess) {
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: responseModel.msg,
          ),
        );
        return;
      }

      response.data = responseModel;

      handler.next(response);
    } on Exception catch (e, s) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: e,
          stackTrace: s,
        ),
      );
    }
  }
}
