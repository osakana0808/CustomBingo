import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
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
          PopupMenuButton<_MenuAction>(
            onSelected: (action) => _onMenuSelected(context, action, l10n),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _MenuAction.privacy,
                child: Text(l10n.menuPrivacyPolicy),
              ),
              PopupMenuItem(
                value: _MenuAction.terms,
                child: Text(l10n.menuTerms),
              ),
              PopupMenuItem(
                value: _MenuAction.about,
                child: Text(l10n.menuAbout),
              ),
            ],
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
          return ListView(
            children: lists
                .map((list) => _ListTile(
                      list: list,
                      onTap: () => _openEdit(context, ref, list),
                      onShare: () => _share(context, list, l10n),
                      onDelete: () => _confirmDelete(context, ref, list, l10n),
                    ))
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEdit(context, ref, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  static const _siteBase = 'https://osakana0808.github.io/CustomBingo';

  Future<void> _onMenuSelected(
      BuildContext context, _MenuAction action, AppLocalizations l10n) async {
    switch (action) {
      case _MenuAction.privacy:
        await _openPage(context, 'privacy.html', l10n);
      case _MenuAction.terms:
        await _openPage(context, 'terms.html', l10n);
      case _MenuAction.about:
        final info = await PackageInfo.fromPlatform();
        if (!context.mounted) return;
        showAboutDialog(
          context: context,
          applicationName: l10n.appName,
          applicationVersion: info.version,
          applicationLegalese: '© 2026 muraemon',
        );
    }
  }

  Future<void> _openPage(
      BuildContext context, String page, AppLocalizations l10n) async {
    final isJa = Localizations.localeOf(context).languageCode == 'ja';
    final url = Uri.parse(isJa ? '$_siteBase/$page' : '$_siteBase/en/$page');
    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.menuLinkError)),
      );
    }
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


enum _MenuAction { privacy, terms, about }

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
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final desc = list.description;
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
                  Icons.list_alt,
                  color: cs.secondary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.name,
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
