import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app.dart';
import '../../l10n/app_localizations.dart';
import '../../models/bingo_list.dart';
import '../../models/lottery_skin.dart';
import '../../providers/draw_provider.dart';
import '../../providers/list_provider.dart';
import '../../providers/purchase_provider.dart';
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
              onPressed: () {
                ref.read(drawProvider.notifier).reset();
                setState(() => _displayedResult = null);
              },
            ),
        ],
      ),
      body: listsAsync.when(
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
      ),
    );
  }

  Widget _buildSetup(List<BingoList> lists, AppLocalizations l10n) {
    final currentSkin = ref.watch(skinProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.drawListLabel,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
          Text(l10n.drawSkinLabel,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
      String? displayedResult, int drawn, int remaining, AppLocalizations l10n) {
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        displayedResult,
                        key: ValueKey(displayedResult),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
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
                  remaining == 0 ? l10n.drawAllDone : l10n.drawNext(remaining)),
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
                child:
                    const Icon(Icons.lock_outline, size: 44, color: WaColors.gold),
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
                    color: WaColors.creamDim, fontSize: 14, height: 1.5),
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
      pageBuilder: (_, __, ___) => LotteryAnimationWidget(
        item: item,
        onComplete: nav.pop,
        skin: skin,
      ),
    );
  }
}
