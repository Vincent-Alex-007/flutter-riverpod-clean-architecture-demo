sealed class Result<ValueT> {
  const Result._();

  const factory Result.data(ValueT value) = _ResultData<ValueT>;

  const factory Result.error(Object error, StackTrace stackTrace) =
      _ResultError<ValueT>;

  bool get hasData => this is _ResultData<ValueT>;

  bool get hasError => this is _ResultError<ValueT>;

  ValueT? get value;

  Object? get error;

  StackTrace? get stackTrace;
}

final class _ResultData<ValueT> extends Result<ValueT> {
  const _ResultData(this.value) : super._();

  @override
  final ValueT value;

  @override
  Object? get error => null;

  @override
  StackTrace? get stackTrace => null;

  @override
  String toString() => '$runtimeType:ResultData(data: $value)';
}

final class _ResultError<ValueT> extends Result<ValueT> {
  const _ResultError(this.error, this.stackTrace) : super._();

  @override
  final Object error;

  @override
  final StackTrace stackTrace;

  @override
  ValueT? get value => null;

  @override
  String toString() =>
      '$runtimeType:ResultError(error: $error, stackTrace: $stackTrace)';
}

extension ResultExtensionX<ValueT> on Result<ValueT> {
  ValueT? get dataOrNull => whenOrNull(data: (value) => value);

  Object? get errorOrNull => whenOrNull(err: (error, _) => error);

  StackTrace? get stackTraceOrNull => whenOrNull(err: (_, stack) => stack);

  NewT when<NewT>({
    required NewT Function(ValueT value) data,
    required NewT Function(Object error, StackTrace stackTrace) err,
  }) => switch (this) {
    _ResultData(:final value) => data(value),
    _ResultError(:final error, :final stackTrace) => err(error, stackTrace),
  };

  NewT whenOrElse<NewT>({
    required NewT Function() orElse,
    NewT Function(ValueT value)? data,
    NewT Function(Object error, StackTrace stackTrace)? err,
  }) =>
      when(data: data ?? (_) => orElse(), err: err ?? (err, stack) => orElse());

  NewT? whenOrNull<NewT>({
    NewT Function(ValueT value)? data,
    NewT Function(Object error, StackTrace stackTrace)? err,
  }) => when(data: data ?? (_) => null, err: err ?? (err, stack) => null);

  NewT map<NewT>({
    required NewT Function(Result<ValueT> data) data,
    required NewT Function(Result<ValueT> error) error,
  }) => switch (this) {
    _ResultData() => data(this),
    _ResultError() => error(this),
  };

  NewT mapOrElse<NewT>({
    NewT Function(Result<ValueT> data)? data,
    NewT Function(Result<ValueT> error)? error,
    required NewT Function() orElse,
  }) => map(
    data: (value) => data != null ? data(value) : orElse(),
    error: (err) => error != null ? error(err) : orElse(),
  );

  NewT? mapOrNull<NewT>({
    NewT? Function(Result<ValueT> value)? data,
    NewT? Function(Result<ValueT> error)? error,
  }) => map(
    data: (value) => data != null ? data(value) : null,
    error: (err) => error != null ? error(err) : null,
  );

  Result<NewT> link<NewT>(NewT Function(ValueT value) transform) =>
      switch (this) {
        _ResultData(:final value) => Result.data(transform(value)),
        _ResultError(:final error, :final stackTrace) => Result.error(
          error,
          stackTrace,
        ),
      };

  Future<Result<NewT>> flatLink<NewT>(
    Future<Result<NewT>> Function(ValueT value) data,
  ) async => switch (this) {
    _ResultData(:final value) => await data(value),
    _ResultError(:final error, :final stackTrace) => _ResultError(
      error,
      stackTrace,
    ),
  };
}
