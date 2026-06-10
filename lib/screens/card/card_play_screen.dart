import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../models/bingo_card.dart';
import '../../providers/card_provider.dart';
import '../../widgets/ad_banner.dart';

class CardPlayScreen extends ConsumerWidget {
  const CardPlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final card = ref.watch(cardProvider);
    if (card == null) {
      return Scaffold(body: Center(child: Text(l10n.cardPlayEmpty)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cardPlayTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.cardPlayReset,
            onPressed: () {
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
                  colors: [Color(0xFF7A1020), Color(0xFFCC3333), Color(0xFF7A1020)],
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
              ? [BoxShadow(
                  color: const Color(0xFFCC3333).withValues(alpha: 0.3),
                  blurRadius: 6)]
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
                  fontWeight: (isMarked || isFree) ? FontWeight.bold : FontWeight.normal,
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
