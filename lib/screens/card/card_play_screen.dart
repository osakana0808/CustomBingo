import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../constants.dart';
import '../../l10n/app_localizations.dart';
import '../../models/bingo_card.dart';
import '../../models/saved_bingo_card.dart';
import '../../providers/card_provider.dart';
import '../../providers/list_provider.dart';
import '../../providers/saved_card_provider.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/save_name_dialog.dart';

class CardPlayScreen extends ConsumerWidget {
  const CardPlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final card = ref.watch(cardProvider);
    if (card == null) {
      return Scaffold(body: Center(child: Text(l10n.cardPlayEmpty)));
    }

    // ゲーム進行中（マークあり）は、誤って閉じて二度と同じカードに
    // 戻れなくなるのを防ぐため、閉じる前に確認する。
    // ただし保存後に変更がなければ復元できるので確認は省略する。
    final hasProgress = card.cells.any(
      (row) => row.any((c) => c.isMarked && !c.isFree),
    );
    final savedSignature = ref.watch(lastSavedCardSignatureProvider);
    final hasUnsavedProgress =
        hasProgress && cardSignature(card) != savedSignature;

    return PopScope(
      canPop: !hasUnsavedProgress,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.cardPlayExitTitle),
            content: Text(l10n.cardPlayExitMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.cardPlayExitCancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.cardPlayExitConfirm),
              ),
            ],
          ),
        );
        if (confirmed == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.cardPlayTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_add_outlined),
              tooltip: l10n.cardSave,
              onPressed: () => _saveCard(context, ref, card, l10n),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: l10n.cardPlayReset,
              // 誤タップでマークが全消去されるのを防ぐため、進行中は確認する
              onPressed: () async {
                if (hasProgress) {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.cardPlayResetConfirmTitle),
                      content: Text(l10n.cardPlayResetConfirmMessage),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(l10n.cardPlayResetCancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l10n.cardPlayResetConfirm),
                        ),
                      ],
                    ),
                  );
                  if (confirmed != true) return;
                }
                var updated = card;
                for (int r = 0; r < card.size; r++) {
                  for (int c = 0; c < card.size; c++) {
                    final cell = card.cells[r][c];
                    if (!cell.isFree && cell.isMarked) {
                      updated = updated.markCell(r, c);
                    }
                  }
                }
                ref.read(cardProvider.notifier).setCard(updated);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            if (card.hasBingo)
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF7A1020),
                      Color(0xFFCC3333),
                      Color(0xFF7A1020),
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  l10n.cardPlayBingo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF0D060),
                    letterSpacing: 4,
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _BingoGrid(card: card),
              ),
            ),
            const SafeArea(top: false, child: AdBanner()),
          ],
        ),
      ),
    );
  }

  // 現在のカード（マーク状態を含む）を名前付きで保存する
  Future<void> _saveCard(
    BuildContext context,
    WidgetRef ref,
    BingoCard card,
    AppLocalizations l10n,
  ) async {
    final lists = ref.read(bingoListsProvider).valueOrNull ?? [];
    String listName = '';
    for (final l in lists) {
      if (l.id == card.listId) {
        listName = l.name;
        break;
      }
    }
    final existing = ref.read(savedCardsProvider).valueOrNull ?? [];

    // 上限に達している場合は上書き保存（または削除を促す）
    if (existing.length >= kMaxSavedSlots) {
      final targetId = await showSaveOverwritePicker(
        context: context,
        title: l10n.saveLimitTitle,
        message: l10n.saveLimitMessage,
        cancelLabel: l10n.listCancel,
        entries: [
          for (final c in existing)
            OverwriteEntry(
              id: c.id,
              name: c.name,
              subtitle: l10n.cardResumeSubtitle(
                  c.listName, '${c.size}×${c.size}', c.markedCount),
            ),
        ],
      );
      if (targetId == null || !context.mounted) return;
      final target = existing.firstWhere((c) => c.id == targetId);
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(l10n.saveOverwriteConfirm(target.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.listCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.saveOverwrite),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      final updated = SavedBingoCard.fromCard(
        id: target.id,
        name: target.name,
        listName: listName,
        card: card,
        updatedAt: DateTime.now(),
      );
      await ref.read(savedCardsProvider.notifier).save(updated);
      ref.read(lastSavedCardSignatureProvider.notifier).state =
          cardSignature(card);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.saveOverwriteSuccess(updated.name))),
        );
      }
      return;
    }

    // 通常の新規保存
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => SaveNameDialog(
        initial: listName,
        title: l10n.cardSaveDialogTitle,
        hint: l10n.cardSaveDialogHint,
        okLabel: l10n.cardSaveDialogOk,
        cancelLabel: l10n.cardSaveDialogCancel,
      ),
    );
    if (name == null || name.isEmpty) return;
    const uuid = Uuid();
    final saved = SavedBingoCard.fromCard(
      id: uuid.v4(),
      name: name,
      listName: listName,
      card: card,
      updatedAt: DateTime.now(),
    );
    await ref.read(savedCardsProvider.notifier).save(saved);
    ref.read(lastSavedCardSignatureProvider.notifier).state =
        cardSignature(card);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cardSaveSuccess(saved.name))),
      );
    }
  }
}

class _BingoGrid extends ConsumerWidget {
  final BingoCard card;
  const _BingoGrid({required this.card});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 横持ちでも縦持ちでもカード全体が画面内に収まるよう、利用可能な
    // 短辺に合わせた正方形領域にグリッドを収め、スクロールさせない
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.biggest.shortestSide;
        return Center(
          child: SizedBox(
            width: side,
            height: side,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: card.size,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: card.size * card.size,
              itemBuilder: (context, index) {
                final row = index ~/ card.size;
                final col = index % card.size;
                final cell = card.cells[row][col];
                return _BingoCell(
                  cell: cell,
                  onTap: () =>
                      ref.read(cardProvider.notifier).toggleCell(row, col),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _BingoCell extends StatelessWidget {
  final BingoCell cell;
  final VoidCallback onTap;

  const _BingoCell({required this.cell, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMarked = cell.isMarked;
    final isFree = cell.isFree;

    Color bgColor;
    Color textColor;
    Color borderColor;

    if (isFree) {
      bgColor = const Color(0xFF3A2E00);
      textColor = const Color(0xFFF0D060);
      borderColor = const Color(0xFFD4AF37);
    } else if (isMarked) {
      bgColor = const Color(0xFF7A1020);
      textColor = const Color(0xFFF5F0E8);
      borderColor = const Color(0xFFCC3333);
    } else {
      bgColor = colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurface;
      borderColor = colorScheme.outlineVariant;
    }

    return GestureDetector(
      onTap: isFree ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: isMarked ? 1.5 : 1),
          boxShadow: isMarked
              ? [
                  BoxShadow(
                    color: const Color(0xFFCC3333).withValues(alpha: 0.3),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                cell.word,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: (isMarked || isFree)
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
