import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';
import '../../app.dart';
import '../../l10n/app_localizations.dart';
import '../../models/bingo_list.dart';
import '../../models/draw_session.dart';
import '../../models/lottery_skin.dart';
import '../../models/saved_draw_session.dart';
import '../../providers/draw_provider.dart';
import '../../providers/list_provider.dart';
import '../../providers/purchase_provider.dart';
import '../../providers/saved_session_provider.dart';
import '../../providers/skin_provider.dart';
import '../paywall_screen.dart';
import 'history_screen.dart';
import 'lottery_animation.dart';

class DrawScreen extends ConsumerStatefulWidget {
  const DrawScreen({super.key});

  @override
  ConsumerState<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends ConsumerState<DrawScreen> {
  BingoList? _selectedList;
  bool _drawing = false;
  // アニメーション終了後にのみ更新し、結果を事前に見せない
  String? _displayedResult;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entitlementAsync = ref.watch(entitlementProvider);

    if (entitlementAsync.isLoading && !entitlementAsync.hasValue) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (entitlementAsync.valueOrNull != true) {
      return _buildLockedScreen(context, l10n);
    }

    final listsAsync = ref.watch(bingoListsProvider);
    final session = ref.watch(drawProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.drawTitle),
        actions: [
          if (session != null)
            IconButton(
              icon: const Icon(Icons.bookmark_add_outlined),
              tooltip: l10n.drawSave,
              onPressed: () => _saveSession(session, l10n),
            ),
          if (session != null)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: l10n.drawHistory,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
            ),
          if (session != null)
            IconButton(
              icon: const Icon(Icons.stop_circle_outlined),
              tooltip: l10n.drawStop,
              onPressed: () => _confirmStop(l10n),
            ),
        ],
      ),
      body: _buildBody(listsAsync, session, l10n),
    );
  }

  // 終了すると抽選履歴が失われ復帰できないため、終了前に確認する
  Future<void> _confirmStop(AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.drawStopConfirmTitle),
        content: Text(l10n.drawStopConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.drawStopCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.drawStopConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      ref.read(drawProvider.notifier).reset();
      setState(() => _displayedResult = null);
    }
  }

  // 現在の進行状況を名前付きで保存する（麻雀など長時間の進行を中断・再開できる）
  Future<void> _saveSession(DrawSession session, AppLocalizations l10n) async {
    final lists = ref.read(bingoListsProvider).valueOrNull ?? [];
    BingoList? list;
    for (final l in lists) {
      if (l.id == session.listId) {
        list = l;
        break;
      }
    }
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => _SaveSessionDialog(initial: list?.name ?? ''),
    );
    if (name == null || name.isEmpty) return;
    const uuid = Uuid();
    final saved = SavedDrawSession(
      id: uuid.v4(),
      name: name,
      listId: session.listId,
      listName: list?.name ?? '',
      drawnItems: session.drawnItems,
      remaining: session.remaining,
      updatedAt: DateTime.now(),
    );
    await ref.read(savedSessionsProvider.notifier).save(saved);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.drawSaveSuccess(saved.name))),
      );
    }
  }

  void _resume(SavedDrawSession saved) {
    setState(() => _displayedResult =
        saved.drawnItems.isEmpty ? null : saved.drawnItems.last);
    ref.read(drawProvider.notifier).restore(saved.toDrawSession());
  }

  Future<void> _showResumeSheet(AppLocalizations l10n) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetCtx) => Consumer(
        builder: (context, ref, _) {
          final sessions =
              ref.watch(savedSessionsProvider).valueOrNull ?? [];
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    l10n.drawResumeTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (sessions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.drawResumeEmpty),
                  ),
                for (final s in sessions)
                  ListTile(
                    title: Text(s.name),
                    subtitle: Text(l10n.drawResumeSubtitle(
                        s.listName, s.drawnItems.length, s.remaining.length)),
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      _resume(s);
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: l10n.drawResumeDelete,
                      onPressed: () =>
                          ref.read(savedSessionsProvider.notifier).delete(s.id),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    AsyncValue<List<BingoList>> listsAsync,
    DrawSession? session,
    AppLocalizations l10n,
  ) {
    return listsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l10n.listError(e.toString()))),
      data: (lists) {
        _selectedList ??= lists.isNotEmpty ? lists.first : null;

        if (session == null) {
          return _buildSetup(lists, l10n);
        }
        return _buildDraw(
          _displayedResult,
          session.drawnItems.length,
          session.remaining.length,
          l10n,
        );
      },
    );
  }

  Widget _buildSetup(List<BingoList> lists, AppLocalizations l10n) {
    final currentSkin = ref.watch(skinProvider);
    final savedCount = ref.watch(savedSessionsProvider).valueOrNull?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.drawListLabel,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<BingoList>(
            initialValue: _selectedList,
            decoration: const InputDecoration(),
            items: lists
                .map((l) => DropdownMenuItem(value: l, child: Text(l.name)))
                .toList(),
            onChanged: (v) => setState(() => _selectedList = v),
          ),
          const SizedBox(height: 32),

          // ─── スキン選択 ──────────────────────────────────────
          Text(
            l10n.drawSkinLabel,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: LotterySkin.values.map((skin) {
              final selected = currentSkin == skin;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () => ref.read(skinProvider.notifier).setSkin(skin),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selected
                            ? WaColors.gold.withValues(alpha: 0.15)
                            : WaColors.navyCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? WaColors.gold
                              : WaColors.gold.withValues(alpha: 0.2),
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            skin.assetPath,
                            width: 64,
                            height: 64,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            skin == LotterySkin.wooden
                                ? l10n.drawSkinWooden
                                : l10n.drawSkinCasino,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selected
                                  ? WaColors.gold
                                  : WaColors.creamDim,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          if (savedCount > 0) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.bookmark_outline),
              label: Text(l10n.drawResumeButton(savedCount)),
              onPressed: () => _showResumeSheet(l10n),
            ),
          ],

          const Spacer(),
          FilledButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: Text(l10n.drawStart),
            onPressed: _selectedList != null ? _start : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDraw(
    String? displayedResult,
    int drawn,
    int remaining,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            l10n.drawRemaining(remaining, drawn),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: Center(
            child: displayedResult == null
                ? Text(
                    l10n.drawHint,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.drawResult,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        displayedResult,
                        key: ValueKey(displayedResult),
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 400.ms),
                    ],
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32),
          child: SizedBox(
            width: double.infinity,
            height: 64,
            child: FilledButton.icon(
              icon: _drawing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.casino),
              label: Text(
                remaining == 0 ? l10n.drawAllDone : l10n.drawNext(remaining),
              ),
              onPressed: (remaining == 0 || _drawing) ? null : _draw,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockedScreen(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.drawTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: WaColors.navyCard,
                  border: Border.all(
                    color: WaColors.gold.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 44,
                  color: WaColors.gold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.drawLocked,
                style: const TextStyle(
                  color: WaColors.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.drawLockedSub,
                style: const TextStyle(
                  color: WaColors.creamDim,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                icon: const Icon(Icons.lock_open),
                label: Text(l10n.drawUnlock),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => const PaywallScreen(),
                    ),
                  );
                  if (mounted) {
                    ref.read(entitlementProvider.notifier).refresh();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _start() {
    final list = _selectedList;
    if (list == null) return;
    setState(() => _displayedResult = null);
    ref
        .read(drawProvider.notifier)
        .start(list.id, list.items.map((i) => i.word).toList());
  }

  Future<void> _draw() async {
    setState(() => _drawing = true);
    ref.read(drawProvider.notifier).drawNext();
    final drawnItem = ref.read(drawProvider)?.lastDrawn;
    if (drawnItem != null && mounted) {
      await _showLotteryAnimation(drawnItem);
      // アニメーション終了後にのみ結果を画面に反映
      if (mounted) setState(() => _displayedResult = drawnItem);
    }
    if (mounted) setState(() => _drawing = false);
  }

  Future<void> _showLotteryAnimation(String item) async {
    final nav = Navigator.of(context);
    final skin = ref.read(skinProvider);
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      pageBuilder: (_, __, ___) =>
          LotteryAnimationWidget(item: item, onComplete: nav.pop, skin: skin),
    );
  }
}

class _SaveSessionDialog extends StatefulWidget {
  const _SaveSessionDialog({required this.initial});
  final String initial;

  @override
  State<_SaveSessionDialog> createState() => _SaveSessionDialogState();
}

class _SaveSessionDialogState extends State<_SaveSessionDialog> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.drawSaveDialogTitle),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        decoration: InputDecoration(hintText: l10n.drawSaveDialogHint),
        onSubmitted: (v) => Navigator.pop(context, v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.drawSaveDialogCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _ctrl.text.trim()),
          child: Text(l10n.drawSaveDialogOk),
        ),
      ],
    );
  }
}
