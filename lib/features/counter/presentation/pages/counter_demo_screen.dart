import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/counter_load_result.dart';
import '../providers/counter_riverpod.dart';

class CounterDemoScreen extends ConsumerWidget {
  const CounterDemoScreen({super.key});

  static String _sourceLabel(CounterValueSource source) {
    return switch (source) {
      CounterValueSource.remote => '来源：远程（已同步本地）',
      CounterValueSource.localFallback => '来源：本地缓存（远程不可用或失败）',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncResult = ref.watch(counterRiverpodProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('分层 Demo · 远程 + 本地')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(counterRiverpodProvider.notifier).reload(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            asyncResult.when(
              data: (result) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${result?.value}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _sourceLabel(result?.source ?? CounterValueSource.remote),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: () =>
                        ref.read(counterRiverpodProvider.notifier).increment(),
                    child: const Text('自增（写本地 → 模拟推送远程）'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '流程：领域定义仓库与数据源端口；基础设施实现模拟远程与 SharedPreferences；'
                    '仓库内编排「远程优先、失败读本地」。',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '下拉可重新 load（再次请求模拟远程）。',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text('Error: $e', textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
