final class AppException<E extends Object?> implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.error,
    this.stackTrace,
  });

  final String message;
  final int? code;
  final E? error;
  final StackTrace? stackTrace;

  @override
  String toString() => '[$code]:$message';
}

final class BusinessException extends AppException {
  const BusinessException({
    required super.message,
    super.code,
    super.error,
    super.stackTrace,
  });
}

final class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.error,
    super.stackTrace,
  });
}

final class JsonException extends AppException {
  const JsonException({
    required super.message,
    super.code,
    super.error,
    super.stackTrace,
  });
}
