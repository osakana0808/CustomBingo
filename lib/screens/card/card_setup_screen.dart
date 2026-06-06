import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/bingo_list.dart';
import '../../providers/list_provider.dart';
import '../../providers/card_provider.dart';
import '../../services/card_service.dart';
import 'card_play_screen.dart';

class CardSetupScreen extends ConsumerStatefulWidget {
  const CardSetupScreen({super.key});

  @override
  ConsumerState<CardSetupScreen> createState() => _CardSetupScreenState();
}

class _CardSetupScreenState extends ConsumerState<CardSetupScreen> {
  int _size = 5;
  bool _hasFreeSpace = true;
  BingoList? _selectedList;

  @override
  Widget build(BuildContext context) {
    final listsAsync = ref.watch(bingoListsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('カードを作成')),
      body: listsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('エラー: $e')),
        data: (lists) {
          _selectedList ??= lists.isNotEmpty ? lists.first : null;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('リストを選択', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<BingoList>(
                initialValue: _selectedList,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: lists
                    .map((l) => DropdownMenuItem(value: l, child: Text(l.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedList = v),
              ),
              const SizedBox(height: 24),
              const Text('マスのサイズ', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 3, label: Text('3×3')),
                  ButtonSegment(value: 4, label: Text('4×4')),
                  ButtonSegment(value: 5, label: Text('5×5')),
                ],
                selected: {_size},
                onSelectionChanged: (s) => setState(() => _size = s.first),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('フリーマス（中央）'),
                value: _hasFreeSpace,
                onChanged: (v) => setState(() => _hasFreeSpace = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),
              if (_selectedList != null)
                _buildRequirementNote(),
              const SizedBox(height: 16),
              FilledButton.icon(
                icon: const Icon(Icons.grid_view),
                label: const Text('カードを生成'),
                onPressed: _selectedList != null ? _generate : null,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRequirementNote() {
    final needed = _hasFreeSpace ? _size * _size - 1 : _size * _size;
    final have = _selectedList?.items.length ?? 0;
    final ok = have >= needed;
    return Text(
      '必要な単語数: $needed件（現在 $have件）',
      style: TextStyle(
        color: ok ? Colors.green : Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _generate() {
    final list = _selectedList;
    if (list == null) return;
    try {
      final card = CardService.generate(
        list: list,
        size: _size,
        hasFreeSpace: _hasFreeSpace,
      );
      ref.read(cardProvider.notifier).setCard(card);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CardPlayScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
