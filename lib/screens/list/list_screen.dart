import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/bingo_list.dart';
import '../../providers/list_provider.dart';
import '../../services/share_service.dart';
import 'list_edit_screen.dart';
import 'import_screen.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(bingoListsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ビンゴリスト'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'インポート',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ImportScreen()),
            ).then((_) => ref.read(bingoListsProvider.notifier).reload()),
          ),
        ],
      ),
      body: listsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('エラー: $e')),
        data: (lists) {
          if (lists.isEmpty) {
            return const Center(child: Text('リストがありません'));
          }
          final presets = lists.where((l) => l.isPreset).toList();
          final custom = lists.where((l) => !l.isPreset).toList();
          return ListView(
            children: [
              if (custom.isNotEmpty) ...[
                const _SectionHeader('マイリスト'),
                ...custom.map((list) => _ListTile(
                      list: list,
                      onTap: () => _openEdit(context, ref, list),
                      onShare: () => _share(context, list),
                      onDelete: () => _confirmDelete(context, ref, list),
                    )),
              ],
              const _SectionHeader('プリセット'),
              ...presets.map((list) => _ListTile(
                    list: list,
                    onShare: () => _share(context, list),
                  )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEdit(context, ref, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openEdit(BuildContext context, WidgetRef ref, BingoList? list) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ListEditScreen(list: list)),
    ).then((_) => ref.read(bingoListsProvider.notifier).reload());
  }

  Future<void> _share(BuildContext context, BingoList list) async {
    final text = ShareService.encode(list);
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('クリップボードにコピーしました')),
      );
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, BingoList list) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('削除'),
        content: Text('「${list.name}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('削除'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(bingoListsProvider.notifier).delete(list.id);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final BingoList list;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  const _ListTile({
    required this.list,
    this.onTap,
    this.onShare,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(list.isPreset ? Icons.star_outline : Icons.list_alt),
      title: Text(list.name),
      subtitle: Text(
        '${list.items.length}件'
        '${list.description.isNotEmpty ? ' · ${list.description}' : ''}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onShare != null)
            IconButton(
                icon: const Icon(Icons.share_outlined), onPressed: onShare),
          if (onDelete != null)
            IconButton(
                icon: const Icon(Icons.delete_outline), onPressed: onDelete),
        ],
      ),
      onTap: onTap,
    );
  }
}
