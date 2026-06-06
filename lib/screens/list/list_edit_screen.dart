import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../models/bingo_item.dart';
import '../../models/bingo_list.dart';
import '../../providers/list_provider.dart';

class ListEditScreen extends ConsumerStatefulWidget {
  final BingoList? list;
  const ListEditScreen({super.key, this.list});

  @override
  ConsumerState<ListEditScreen> createState() => _ListEditScreenState();
}

class _ListEditScreenState extends ConsumerState<ListEditScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late bool _hasFreeSpace;
  late List<BingoItem> _items;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final list = widget.list;
    _nameCtrl = TextEditingController(text: list?.name ?? '');
    _descCtrl = TextEditingController(text: list?.description ?? '');
    _hasFreeSpace = list?.hasFreeSpace ?? true;
    _items = list != null ? List.of(list.items) : [];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.list != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'リストを編集' : 'リストを作成'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: const Text('保存'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'リスト名',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descCtrl,
            decoration: const InputDecoration(
              labelText: '概要（任意）',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('フリーマス'),
            value: _hasFreeSpace,
            onChanged: (v) => setState(() => _hasFreeSpace = v),
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(),
          Row(
            children: [
              Text('単語リスト（${_items.length}件）',
                  style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('追加'),
                onPressed: _addItem,
              ),
            ],
          ),
          ..._items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            return ListTile(
              dense: true,
              title: Text(item.word),
              contentPadding: EdgeInsets.zero,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: () => _editItem(i),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => setState(() => _items.removeAt(i)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _addItem() async {
    final word = await _showWordDialog(null);
    if (word != null && word.isNotEmpty) {
      const uuid = Uuid();
      setState(() => _items.add(BingoItem(id: uuid.v4(), word: word)));
    }
  }

  Future<void> _editItem(int index) async {
    final word = await _showWordDialog(_items[index].word);
    if (word != null && word.isNotEmpty) {
      setState(() => _items[index] = _items[index].copyWith(word: word));
    }
  }

  Future<String?> _showWordDialog(String? initial) async {
    final ctrl = TextEditingController(text: initial);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(initial == null ? '単語を追加' : '単語を編集'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: '単語を入力'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('キャンセル')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: const Text('OK')),
        ],
      ),
    );
    ctrl.dispose();
    return result;
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('リスト名を入力してください')));
      return;
    }
    setState(() => _saving = true);
    const uuid = Uuid();
    final list = BingoList(
      id: widget.list?.id ?? uuid.v4(),
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      items: _items,
      hasFreeSpace: _hasFreeSpace,
    );
    await ref.read(bingoListsProvider.notifier).save(list);
    if (mounted) Navigator.pop(context);
  }
}
