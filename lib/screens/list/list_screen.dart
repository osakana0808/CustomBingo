import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../models/bingo_list.dart';
import '../../providers/list_provider.dart';
import '../../services/share_service.dart';
import 'list_edit_screen.dart';
import 'import_screen.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final listsAsync = ref.watch(bingoListsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.listTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: l10n.listImportTooltip,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ImportScreen()),
            ).then((_) => ref.read(bingoListsProvider.notifier).reload()),
          ),
        ],
      ),
      body: listsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.listError(e.toString()))),
        data: (lists) {
          if (lists.isEmpty) {
            return Center(child: Text(l10n.listEmpty));
          }
          final presets = lists.where((l) => l.isPreset).toList();
          final custom = lists.where((l) => !l.isPreset).toList();
          return ListView(
            children: [
              if (custom.isNotEmpty) ...[
                _SectionHeader(l10n.listSectionMy),
                ...custom.map((list) => _ListTile(
                      list: list,
                      onTap: () => _openEdit(context, ref, list),
                      onShare: () => _share(context, list, l10n),
                      onDelete: () => _confirmDelete(context, ref, list, l10n),
                    )),
              ],
              _SectionHeader(l10n.listSectionPreset),
              ...presets.map((list) => _ListTile(
                    list: list,
                    onShare: () => _share(context, list, l10n),
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

  Future<void> _share(BuildContext context, BingoList list, AppLocalizations l10n) async {
    final text = ShareService.encode(list);
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.listCopied)),
      );
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, BingoList list, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.listDeleteTitle),
        content: Text(l10n.listDeleteConfirm(list.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.listCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.listDelete),
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
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 1.5,
                  fontSize: 12,
                ),
          ),
        ],
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

  // プリセットは言語設定に応じてローカライズされた名前を表示
  String _displayName(BuildContext context) {
    if (!list.isPreset) return list.name;
    final l10n = AppLocalizations.of(context);
    switch (list.id) {
      case 'preset_numbers':  return l10n.presetNumberName;
      case 'preset_hiragana': return l10n.presetHiraganaName;
      case 'preset_alphabet': return l10n.presetAlphabetName;
      case 'preset_mahjong':  return l10n.presetMahjongName;
      default: return list.name;
    }
  }

  String _displayDesc(BuildContext context) {
    if (!list.isPreset) return list.description;
    final l10n = AppLocalizations.of(context);
    switch (list.id) {
      case 'preset_numbers':  return l10n.presetNumberDesc;
      case 'preset_hiragana': return l10n.presetHiraganaDesc;
      case 'preset_alphabet': return l10n.presetAlphabetDesc;
      case 'preset_mahjong':  return l10n.presetMahjongDesc;
      default: return list.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final desc = _displayDesc(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.outline, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  list.isPreset ? Icons.star_outline : Icons.list_alt,
                  color: cs.secondary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayName(context),
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${l10n.listItemCount(list.items.length)}'
                        '${desc.isNotEmpty ? '  $desc' : ''}',
                        style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (onShare != null)
                  IconButton(
                    icon: Icon(Icons.share_outlined, color: cs.onSurfaceVariant),
                    onPressed: onShare,
                    visualDensity: VisualDensity.compact,
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: cs.onSurfaceVariant),
                    onPressed: onDelete,
                    visualDensity: VisualDensity.compact,
                  ),
                if (onTap != null)
                  Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
