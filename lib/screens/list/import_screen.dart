import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/list_provider.dart';
import '../../services/share_service.dart';

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.importTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.importHint),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.paste),
              label: Text(l10n.importPaste),
              onPressed: _paste,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _import,
              child: Text(l10n.importImport),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      setState(() => _controller.text = data!.text!);
    }
  }

  Future<void> _import() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _error = null);
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = l10n.importEmpty);
      return;
    }
    const uuid = Uuid();
    final list = ShareService.decode(text, uuid.v4());
    if (list == null) {
      setState(() => _error = l10n.importInvalid);
      return;
    }
    await ref.read(bingoListsProvider.notifier).save(list);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.importSuccess(list.name))),
      );
    }
  }
}
