final class AppException<E extends Object?> implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  final String message;
  final int? code;
  final E? cause;
  final StackTrace? stackTrace;

  String? get causeType => cause?.runtimeType.toString();

  String? get firstFrame {
    final raw = stackTrace?.toString();
    if (raw == null || raw.isEmpty) return null;
    for (final line in raw.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }

  @override
  String toString() {
    final typePart = '[$runtimeType]';
    final codePart = code == null ? '' : '[code=$code]';
    final causePart = causeType == null ? '' : '[cause=$causeType]';
    final framePart = firstFrame == null ? '' : ' @$firstFrame';
    return '$typePart$codePart$causePart $message$framePart';
  }
}

final class BusinessException<E extends Object?> extends AppException<E> {
  const BusinessException({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

final class NetworkException<E extends Object?> extends AppException<E> {
  const NetworkException({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

final class JsonException<E extends Object?> extends AppException<E> {
  const JsonException({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}
