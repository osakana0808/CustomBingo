import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/draw_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(drawProvider);
    final drawn = session?.drawnItems ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('抽選履歴（${drawn.length}件）')),
      body: drawn.isEmpty
          ? const Center(child: Text('まだ抽選していません'))
          : ListView.builder(
              itemCount: drawn.length,
              itemBuilder: (context, index) {
                final order = drawn.length - index;
                final word = drawn[drawn.length - 1 - index];
                return ListTile(
                  leading: CircleAvatar(child: Text('$order')),
                  title: Text(word),
                );
              },
            ),
    );
  }
}
