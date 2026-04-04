import 'dart:async';

import 'package:flutter/foundation.dart';

import 'exceptions.dart';
import 'result.dart';

abstract base class UseCase<Params, ValueT> {
  @protected
  FutureOr<Result<ValueT>> execute(Params params);

  FutureOr<Result<ValueT>> call(Params params) async {
    try {
      return await execute(params);
    } on Error {
      rethrow;
    } on AppException catch (e, s) {
      debugPrint('UseCase [$runtimeType] failed: $e');
      return Result.error(e, s);
    }
  }
}

abstract base class NoParamsUseCase<ValueT> {
  @protected
  FutureOr<Result<ValueT>> execute();

  FutureOr<Result<ValueT>> call() async {
    try {
      return await execute();
    } on Error {
      rethrow;
    } on AppException catch (e, s) {
      debugPrint('NoParamsUseCase [$runtimeType] failed: $e');
      return Result.error(e, s);
    }
  }
}
