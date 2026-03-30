import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../config/app_env.dart';
import '../../di/injection.dart';
import '../dio_client.dart';

class _PendingRequest {
  _PendingRequest(this.options, this.handler);
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
}

const String kContentTypeJson = 'application/json';

const String kRefreshUrl = '/api/v1/intel-user/refresh';

const String kAuthorizationHeader = 'Authorization';

@lazySingleton
final class AuthInterceptor extends Interceptor {
  AuthInterceptor(DioClient dioClient) {
    _dio = dioClient.dio;
    // Create a new Dio instance for refreshing tokens
    _tokenRefreshDio = Dio(
      BaseOptions(
        baseUrl: getIt<AppEnv>().baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': kContentTypeJson,
          // If the refresh token needs an API key, add it here
          // 'x-api-key': env.apiKey,
        },
      ),
    );
  }

  late final Dio _dio; // Main Dio instance, for retrying the original request

  // Mutex: Whether a refresh is in progress
  bool _isRefreshing = false;

  // A Dio instance专门用于刷新 Token 的 Dio 实例（无拦截器，防止死锁）
  late final Dio _tokenRefreshDio;

  // A queue of pending requests
  final List<_PendingRequest> _pendingRequests = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 1. Get the token
    final token = '1234567890';

    // 2. If the token exists and the Authorization header is not included, inject it
    if (token.isNotEmpty) {
      options.headers[kAuthorizationHeader] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 1. Check if the status code is 401 and the request is not for the refresh token
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains(kRefreshUrl)) {
      // 2. If a refresh is in progress, add the current request to the queue
      if (_isRefreshing) {
        _pendingRequests.add(_PendingRequest(err.requestOptions, handler));
        return;
      }

      _isRefreshing = true;

      try {
        // 3. Execute the refresh logic
        final newAccessToken = await _refreshTokenWithRetry();

        // 4. Refresh successful: save the new token
        // await _userCubit.saveTokens(access: newAccessToken);

        // 5. Retry the current failed request
        _retryRequest(err.requestOptions, handler, newAccessToken);

        // 6. Retry all requests in the queue
        for (var pending in _pendingRequests) {
          _retryRequest(pending.options, pending.handler, newAccessToken);
        }
      } catch (e) {
        // 7. Handle refresh failure
        _handleRefreshFailure(e, err, handler);
      } finally {
        // 8. Clean up the state
        _isRefreshing = false;
        _pendingRequests.clear();
      }
    } else {
      super.onError(err, handler);
    }
  }

  /// Refresh the token, with exponential backoff retry mechanism
  Future<String> _refreshTokenWithRetry({int maxRetries = 2}) async {
    final refreshToken = '1234567890';

    if (refreshToken.isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: kRefreshUrl),
        type: DioExceptionType.cancel,
        error: 'No refresh token found',
      );
    }

    //Exponential backoff retry
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        //Send the request using _tokenRefreshDio, bypassing the interceptor
        final response = await _tokenRefreshDio.post(
          kRefreshUrl,
          data: {'refresh_token': refreshToken},
        );
        //Modify according to the backend structure
        final newAccessToken = response.data['access_token'];

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          return newAccessToken;
        }
      } catch (e) {
        if (attempt == maxRetries ||
            (e is DioException &&
                (e.response?.statusCode == 401 ||
                    e.response?.statusCode == 403))) {
          rethrow;
        }

        final delay = Duration(seconds: 1 << attempt);
        await Future.delayed(delay);
      }
    }
    throw Exception('Token refresh failed');
  }

  /// Helper method: Retry the request with the new token
  Future<void> _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
    String newToken,
  ) async {
    // Update the token
    requestOptions.headers['Authorization'] = 'Bearer $newToken';

    try {
      // Use the main Dio instance to resend the request
      // Note: Here must create a new Options to avoid reference issues
      final response = await _dio.fetch(requestOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }

  /// Core logic: Handle refresh failure (distinguish between network errors vs authentication failure)
  Future<void> _handleRefreshFailure(
    dynamic error,
    DioException originalError,
    ErrorInterceptorHandler handler,
  ) async {
    bool shouldLogout = true;

    if (error is DioException) {
      final type = error.type;
      // If it's a network connection problem, it should not log out
      if (type == DioExceptionType.connectionTimeout ||
          type == DioExceptionType.sendTimeout ||
          type == DioExceptionType.receiveTimeout ||
          type == DioExceptionType.connectionError ||
          type == DioExceptionType.unknown) {
        shouldLogout = false;
      }

      // If the backend explicitly returns 4xx/5xx, check the status code
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        // Only 401 (Unauthorized) means the Refresh Token is also invalid
        if (statusCode == 401) {
          shouldLogout = true;
        } else if (statusCode >= 500) {
          // The server is down, so the user should not be logged in again
          shouldLogout = false;
        }
      }
    }

    if (shouldLogout) {
      // Clear all tokens locally
      // await _userCubit.deleteTokens();
      // Here you can use EventBus to notify the UI layer to redirect to the login page, or throw a specific exception
    }

    // Reject the current request
    handler.reject(originalError);

    // Reject all requests in the queue
    for (var pending in _pendingRequests) {
      pending.handler.reject(originalError);
    }
  }
}
