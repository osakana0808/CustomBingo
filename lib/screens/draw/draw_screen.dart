import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/bingo_list.dart';
import '../../providers/draw_provider.dart';
import '../../providers/list_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final listsAsync = ref.watch(bingoListsProvider);
    final session = ref.watch(drawProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('抽選'),
        actions: [
          if (session != null)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: '履歴',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
            ),
          if (session != null)
            IconButton(
              icon: const Icon(Icons.stop_circle_outlined),
              tooltip: '終了',
              onPressed: () {
                ref.read(drawProvider.notifier).reset();
              },
            ),
        ],
      ),
      body: listsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('エラー: $e')),
        data: (lists) {
          _selectedList ??= lists.isNotEmpty ? lists.first : null;

          if (session == null) {
            return _buildSetup(lists);
          }
          return _buildDraw(session.lastDrawn, session.drawnItems.length,
              session.remaining.length);
        },
      ),
    );
  }

  Widget _buildSetup(List<BingoList> lists) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('リストを選択',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          DropdownButtonFormField<BingoList>(
            initialValue: _selectedList,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: lists
                .map((l) => DropdownMenuItem(value: l, child: Text(l.name)))
                .toList(),
            onChanged: (v) => setState(() => _selectedList = v),
          ),
          const Spacer(),
          FilledButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('抽選スタート'),
            onPressed: _selectedList != null ? _start : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDraw(String? lastDrawn, int drawn, int remaining) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            '残り $remaining 件 / 抽選済み $drawn 件',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: Center(
            child: lastDrawn == null
                ? Text(
                    'ボタンを押して抽選開始',
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '抽選結果',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lastDrawn,
                        key: ValueKey(lastDrawn),
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary,
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
              label:
                  Text(remaining == 0 ? '全て抽選済み' : '次を引く（残り$remaining件）'),
              onPressed: (remaining == 0 || _drawing) ? null : _draw,
            ),
          ),
        ),
      ],
    );
  }

  void _start() {
    final list = _selectedList;
    if (list == null) return;
    ref
        .read(drawProvider.notifier)
        .start(list.id, list.items.map((i) => i.word).toList());
  }

  Future<void> _draw() async {
    setState(() => _drawing = true);
    // 先に結果を確定させてからアニメーション表示
    ref.read(drawProvider.notifier).drawNext();
    final drawnItem = ref.read(drawProvider)?.lastDrawn;
    if (drawnItem != null && mounted) {
      await _showLotteryAnimation(drawnItem);
    }
    if (mounted) setState(() => _drawing = false);
  }

  Future<void> _showLotteryAnimation(String item) async {
    final nav = Navigator.of(context);
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      pageBuilder: (_, __, ___) => LotteryAnimationWidget(
        item: item,
        onComplete: nav.pop,
      ),
    );
  }
}
