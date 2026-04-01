import 'package:flutter/material.dart';

import '../../../counter/counter.dart';

class DemoModel {
  DemoModel({
    required this.message,
    required this.timestamp,
    required this.id,
    required this.value,
    required this.name,
  });

  final String message;
  final DateTime timestamp;
  final int id;
  final double value;
  final String name;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<DemoModel> future() async {
    await Future.delayed(const Duration(seconds: 2));

    return DemoModel(message: '33434', timestamp: DateTime.now(), id: 123, value: 2311.4141, name: 'fsfs');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: FutureBuilder(
        future: future(),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('No Connection'));
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (asyncSnapshot.hasError) {
                return Center(child: Text('Error: ${asyncSnapshot.error}'));
              } else {
                if (asyncSnapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(asyncSnapshot.data!.message),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () =>
                              const CounterDemoRoute().push(context),
                          child: const Text('打开分层架构 Counter Demo'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('No Data'));
                }
              }
            default:
          }

          return Container();
        },
      ),
    );
  }
}
