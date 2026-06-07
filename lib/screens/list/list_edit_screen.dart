import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
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
    final name = _nameCtrl;
    final desc = _descCtrl;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      name.dispose();
      desc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.list != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.editTitleEdit : l10n.editTitleCreate),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(l10n.editSave),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(labelText: l10n.editNameLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descCtrl,
            decoration: InputDecoration(labelText: l10n.editDescLabel),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(l10n.editFreeSpace),
            value: _hasFreeSpace,
            onChanged: (v) => setState(() => _hasFreeSpace = v),
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(),
          Row(
            children: [
              Text(l10n.editWords(_items.length),
                  style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l10n.editAddWord),
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

  Future<String?> _showWordDialog(String? initial) {
    return showDialog<String>(
      context: context,
      builder: (ctx) => _WordDialog(initial: initial),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.editNameRequired)));
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

class _WordDialog extends StatefulWidget {
  const _WordDialog({this.initial});
  final String? initial;

  @override
  State<_WordDialog> createState() => _WordDialogState();
}

class _WordDialogState extends State<_WordDialog> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl.text = widget.initial ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.initial == null ? l10n.editWordDialogAdd : l10n.editWordDialogEdit),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        decoration: InputDecoration(hintText: l10n.editWordHint),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.listCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _ctrl.text),
          child: Text(l10n.editWordOk),
        ),
      ],
    );
  }
}
