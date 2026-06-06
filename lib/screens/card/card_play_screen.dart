import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/bingo_card.dart';
import '../../providers/card_provider.dart';

class CardPlayScreen extends ConsumerWidget {
  const CardPlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(cardProvider);
    if (card == null) {
      return const Scaffold(body: Center(child: Text('カードがありません')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ビンゴカード'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'リセット',
            onPressed: () {
              // セルの isMarked をすべてリセット（フリーマスは除く）
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
              color: Colors.amber,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Text(
                '🎉 BINGO! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _BingoGrid(card: card),
            ),
          ),
        ],
      ),
    );
  }
}

class _BingoGrid extends ConsumerWidget {
  final BingoCard card;
  const _BingoGrid({required this.card});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
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
          onTap: () => ref.read(cardProvider.notifier).toggleCell(row, col),
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
    if (isFree) {
      bgColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
    } else if (isMarked) {
      bgColor = colorScheme.primary.withAlpha(180);
      textColor = colorScheme.onPrimary;
    } else {
      bgColor = colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurface;
    }

    return GestureDetector(
      onTap: isFree ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isMarked
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
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
                  fontWeight:
                      isMarked ? FontWeight.bold : FontWeight.normal,
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
