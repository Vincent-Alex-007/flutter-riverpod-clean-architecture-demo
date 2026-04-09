import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/currency_format.dart';
import '../../../order/order.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_riverpod.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(productRiverpodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('商品列表'),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: () => const CartRoute().push(context),
                icon: const Icon(Icons.shopping_cart),
              ),
            ],
          ),
        ],
      ),
      body: asyncProducts.when(
        data: (products) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) => _ProductCard(
            product: products[index],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        formatCents(product.priceInCents),
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.red),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '库存: ${product.stock}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: product.stock > 0
                  ? () => ref
                      .read(cartRiverpodProvider.notifier)
                      .addToCart(product.id, 1)
                  : null,
              child: Text(product.stock > 0 ? '加入购物车' : '已售罄'),
            ),
          ],
        ),
      ),
    );
  }
}
