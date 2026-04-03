import 'package:flutter/foundation.dart';

import 'result.dart';

// ==================== UseCase ====================

/// 有参数的 UseCase 基类。
///
/// - [Params] — 输入参数类型
/// - [T] — 输出数据类型
///
/// 用法：
/// ```dart
/// class GetPaymentDetail extends UseCase<int, PaymentDetailsRsp> {
///   GetPaymentDetail();
///
///   @override
///   Future<Result<PaymentDetailsRsp>> execute(int orderId) async {
///     return Result.success(await repository.getPaymentDetail(orderId));
///   }
/// }
/// ```
abstract class UseCase<Params, T> {
  const UseCase();

  /// 子类实现具体业务逻辑
  @protected
  Future<Result<T>> _execute(Params params);

  /// 调用 UseCase，自动捕获异常
  Future<Result<T>> call(Params params) async {
    try {
      return await _execute(params);
    } catch (e, s) {
      debugPrint('UseCase [$runtimeType] failed: $e');
      return Result.failure(e, s);
    }
  }
}

/// 无参数的 UseCase 基类。
///
/// - [T] — 输出数据类型
///
/// 用法：
/// ```dart
/// class GetPaymentMethods extends NoParamsUseCase<List<PaymentMethodItem>> {
///   GetPaymentMethods();
///
///   @override
///   Future<Result<List<PaymentMethodItem>>> execute() async {
///     return Result.success(await repository.getPaymentMethod());
///   }
/// }
/// ```
abstract class NoParamsUseCase<T> {
  const NoParamsUseCase();

  /// 子类实现具体业务逻辑
  @protected
  Future<Result<T>> execute();

  /// 调用 UseCase，自动捕获异常
  Future<Result<T>> call() async {
    try {
      return await execute();
    } catch (e, s) {
      debugPrint('UseCase [$runtimeType] failed: $e');
      return Result.failure(e, s);
    }
  }
}

/// 同步 UseCase 基类（无需 async 的场景）。
abstract class SyncUseCase<Params, T> {
  const SyncUseCase();

  @protected
  Result<T> _execute(Params params);

  Result<T> call(Params params) {
    try {
      return _execute(params);
    } catch (e, s) {
      debugPrint('SyncUseCase [$runtimeType] failed: $e');
      return Result.failure(e, s);
    }
  }
}
