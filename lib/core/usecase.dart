/// [T]：success type, can be `void`
/// [P]：input type, use [NoParams] when no params
/// [NoParams]：no params for [UseCase]
///
/// ```dart
/// final class Logout implements UseCase<void, NoParams> {
///   @override
///   Future<void> call(NoParams _) async { ... }
/// }
/// ```
abstract interface class UseCase<T, P extends Object?> {
  Future<T> call(P params);
}

/// no params for [UseCase]
final class NoParams {
  const NoParams();
}
