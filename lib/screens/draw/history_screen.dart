import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/draw_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(drawProvider);
    final drawn = session?.drawnItems ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle(drawn.length))),
      body: drawn.isEmpty
          ? Center(child: Text(l10n.historyEmpty))
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
