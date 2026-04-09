import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/price_breakdown.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/submit_order.dart';
import '../providers/cart_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCart = ref.watch(cartRiverpodProvider);
    final asyncPreview = ref.watch(orderPreviewRiverpodProvider);
    final asyncSubmit = ref.watch(submitOrderRiverpodProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('购物车')),
      body: asyncCart.when(
        data: (items) => items.isEmpty
            ? const Center(child: Text('购物车为空，去添加商品吧'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) =>
                          _CartItemTile(item: items[index]),
                    ),
                  ),
                  // 价格明细
                  _PriceBreakdownCard(asyncPreview: asyncPreview),
                  // 提交按钮
                  _SubmitBar(
                    asyncPreview: asyncPreview,
                    asyncSubmit: asyncSubmit,
                    onSubmit: () async {
                      await ref
                          .read(submitOrderRiverpodProvider.notifier)
                          .submit();
                      // 提交后刷新购物车和商品列表
                      ref.invalidate(cartRiverpodProvider);
                      if (context.mounted) {
                        final submitState =
                            ref.read(submitOrderRiverpodProvider);
                        submitState.whenOrNull(
                          data: (result) {
                            if (result != null) {
                              _showOrderSuccess(context, result);
                            }
                          },
                          error: (e, _) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showOrderSuccess(BuildContext context, OrderSubmitResult result) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('下单成功'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('订单号: #${result.orderId}'),
            Text('商品数: ${result.itemCount} 件'),
            const Divider(),
            Text(
              '小计: ${PriceBreakdown.format(result.breakdown.subtotalInCents)}',
            ),
            if (result.breakdown.discountInCents > 0)
              Text(
                '折扣: -${PriceBreakdown.format(result.breakdown.discountInCents)}'
                '（${result.breakdown.discountReason}）',
                style: const TextStyle(color: Colors.green),
              ),
            Text(
              '税费: ${PriceBreakdown.format(result.breakdown.taxInCents)}',
            ),
            const Divider(),
            Text(
              '合计: ${PriceBreakdown.format(result.breakdown.totalInCents)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('返回商品列表'),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  const _CartItemTile({required this.item});

  final CartItemEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) =>
          ref.read(cartRiverpodProvider.notifier).remove(item.id),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Text(item.productName),
          subtitle: Text(
            '${PriceBreakdown.format(item.priceInCents)} x ${item.quantity}',
          ),
          trailing: Text(
            PriceBreakdown.format(item.priceInCents * item.quantity),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceBreakdownCard extends StatelessWidget {
  const _PriceBreakdownCard({required this.asyncPreview});

  final AsyncValue<PriceBreakdown?> asyncPreview;

  @override
  Widget build(BuildContext context) {
    return asyncPreview.when(
      data: (breakdown) {
        if (breakdown == null) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Column(
            children: [
              _row(context, '小计',
                  PriceBreakdown.format(breakdown.subtotalInCents)),
              if (breakdown.discountInCents > 0)
                _row(
                  context,
                  '折扣（${breakdown.discountReason}）',
                  '-${PriceBreakdown.format(breakdown.discountInCents)}',
                  valueColor: Colors.green,
                ),
              _row(context, '税费（6%）',
                  PriceBreakdown.format(breakdown.taxInCents)),
              const Divider(height: 16),
              _row(
                context,
                '合计',
                PriceBreakdown.format(breakdown.totalInCents),
                isBold: true,
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('计算出错: $e'),
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    final style = isBold
        ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            value,
            style: (style ?? const TextStyle()).copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}

class _SubmitBar extends StatelessWidget {
  const _SubmitBar({
    required this.asyncPreview,
    required this.asyncSubmit,
    required this.onSubmit,
  });

  final AsyncValue<PriceBreakdown?> asyncPreview;
  final AsyncValue<OrderSubmitResult?> asyncSubmit;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isLoading = asyncSubmit.isLoading;
    final total = asyncPreview.value?.totalInCents;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: isLoading || total == null ? null : onSubmit,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  total != null
                      ? '提交订单 ${PriceBreakdown.format(total)}'
                      : '提交订单',
                ),
        ),
      ),
    );
  }
}
