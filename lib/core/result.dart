// ==================== Result ====================

/// 统一的业务结果类型，替代 bool 返回值和 try-catch 模式。
///
/// 用法：
/// ```dart
/// final result = await someUseCase(params);
/// switch (result) {
///   case Success(:final data):
///     // 处理成功
///   case Failure(:final exception, :final stackTrace):
///     // 处理失败
/// }
///
/// // 或者使用便捷方法
/// result.when(
///   success: (data) => print(data),
///   failure: (e, s) => print(e),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// 创建成功结果
  const factory Result.success(T data) = Success<T>;

  /// 创建失败结果
  const factory Result.failure(Object exception, [StackTrace? stackTrace]) = Failure<T>;

  /// 是否成功
  bool get isSuccess => this is Success<T>;

  /// 是否失败
  bool get isFailure => this is Failure<T>;

  /// 获取成功数据，失败时返回 null
  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  /// 获取成功数据，失败时返回 [defaultValue]
  T dataOrElse(T defaultValue) => switch (this) {
        Success(:final data) => data,
        Failure() => defaultValue,
      };

  /// 模式匹配，必须同时处理成功和失败。
  ///
  /// ```dart
  /// // 示例1：在 UI 层根据结果展示不同内容
  /// final result = await getPaymentDetail(orderId);
  /// final message = result.when(
  ///   success: (detail) => '应付金额: ${detail.payAmount}',
  ///   failure: (e, s) => '获取支付详情失败: $e',
  /// );
  ///
  /// // 示例2：在控制器中处理支付结果
  /// final payResult = await processPayment(params);
  /// payResult.when(
  ///   success: (transaction) {
  ///     KPToast.show('支付成功');
  ///     navigator.pushPaymentResult(transaction);
  ///   },
  ///   failure: (e, s) {
  ///     KPToast.show('支付失败: $e');
  ///     debugPrint('$s');
  ///   },
  /// );
  ///
  /// // 示例3：转换为 AsyncValue 供 Riverpod 使用
  /// state = result.when(
  ///   success: (data) => AsyncData(data),
  ///   failure: (e, s) => AsyncError(e, s ?? StackTrace.current),
  /// );
  /// ```
  R when<R>({
    required R Function(T data) success,
    required R Function(Object exception, StackTrace? stackTrace) failure,
  }) =>
      switch (this) {
        Success(:final data) => success(data),
        Failure(:final exception, :final stackTrace) => failure(exception, stackTrace),
      };

  /// 模式匹配（只关心部分情况时使用）。
  ///
  /// ```dart
  /// // 示例1：只关心成功，失败时返回默认值
  /// final methods = result.maybeWhen(
  ///   success: (list) => list.where((m) => m.paymentState == 1).toList(),
  ///   orElse: () => <PaymentMethodItem>[],
  /// );
  ///
  /// // 示例2：只关心失败（用于错误上报），成功时不做额外处理
  /// result.maybeWhen(
  ///   failure: (e, s) {
  ///     errorReporter.report(e, s);
  ///     return null;
  ///   },
  ///   orElse: () => null,
  /// );
  /// ```
  R maybeWhen<R>({
    required R Function() orElse,
    R Function(T data)? success,
    R Function(Object exception, StackTrace? stackTrace)? failure,
  }) =>
      switch (this) {
        Success(:final data) => success != null ? success(data) : orElse(),
        Failure(:final exception, :final stackTrace) => failure != null ? failure(exception, stackTrace) : orElse(),
      };

  /// 同步转换成功数据的类型，失败时原样透传。
  ///
  /// ```dart
  /// // 示例1：从支付详情中提取商品列表
  /// final Result<List<CartProductItem>> itemsResult =
  ///     detailResult.map((detail) => detail.cartItemList);
  ///
  /// // 示例2：将金额格式化为字符串
  /// final Result<String> display =
  ///     amountResult.map((amount) => '${currency.symbol}${amount.toStringAsFixed(2)}');
  ///
  /// // 示例3：多次 map 链式转换
  /// final Result<int> count = getPaymentDetail(orderId)
  ///     .map((detail) => detail.billList)
  ///     .map((bills) => bills.where((b) => b.billState == 3).length);
  /// ```
  Result<R> map<R>(R Function(T data) transform) => switch (this) {
        Success(:final data) => Result.success(transform(data)),
        Failure(:final exception, :final stackTrace) => Result.failure(exception, stackTrace),
      };

  /// 链式异步转换，用于将多个可能失败的异步操作串联。
  /// 前一步失败时会短路，不再执行后续操作。
  ///
  /// ```dart
  /// // 示例1：获取支付详情 → 拆分 → 发起支付（任意一步失败即中断）
  /// final result = await getPaymentDetail(orderId)
  ///     .flatMap((detail) => splitByAmount(detail.orderId, amount))
  ///     .flatMap((bill) => processPayment(bill.billId, paymentMethod));
  ///
  /// // 示例2：校验订单 → 创建交易记录 → 调用 POS 设备
  /// final result = await validateOrder(orderId).flatMap((order) async {
  ///   final record = await createLocalPaymentRecords(order);
  ///   return record.flatMap((r) => sendToPosDevice(r.outTradeNo));
  /// });
  ///
  /// // 示例3：配合 mapResult / flatMapResult 扩展方法在 Future 上直接链式调用
  /// final result = await getPaymentDetail(orderId)          // Future<Result<Detail>>
  ///     .mapResult((detail) => detail.billList)              // Future<Result<List<Bill>>>
  ///     .flatMapResult((bills) => payFirstBill(bills.first));// Future<Result<Transaction>>
  /// ```
  Future<Result<R>> flatMap<R>(Future<Result<R>> Function(T data) transform) async => switch (this) {
        Success(:final data) => await transform(data),
        Failure(:final exception, :final stackTrace) => Result.failure(exception, stackTrace),
      };
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  String toString() => 'Success($data)';
}

final class Failure<T> extends Result<T> {
  final Object exception;
  final StackTrace? stackTrace;
  const Failure(this.exception, [this.stackTrace]);

  @override
  String toString() => 'Failure($exception)';
}

// ==================== Result 扩展 ====================

extension ResultFutureX<T> on Future<Result<T>> {
  /// 对 Future<Result<T>> 直接链式 map
  Future<Result<R>> mapResult<R>(R Function(T data) transform) async {
    return (await this).map(transform);
  }

  /// 对 Future<Result<T>> 直接链式 flatMap
  Future<Result<R>> flatMapResult<R>(Future<Result<R>> Function(T data) transform) async {
    return (await this).flatMap(transform);
  }
}
