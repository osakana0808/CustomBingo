import 'package:flutter/material.dart';

/// 上書き候補の1件分の表示情報。
class OverwriteEntry {
  final String id;
  final String name;
  final String subtitle;
  const OverwriteEntry({
    required this.id,
    required this.name,
    required this.subtitle,
  });
}

/// 保存が上限に達したとき、上書きする保存先を選ばせるダイアログ。
/// 選択された保存先の id を返す。キャンセル時は null。
Future<String?> showSaveOverwritePicker({
  required BuildContext context,
  required String title,
  required String message,
  required String cancelLabel,
  required List<OverwriteEntry> entries,
}) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(message),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final e in entries)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(e.name),
                      subtitle: Text(e.subtitle),
                      onTap: () => Navigator.pop(ctx, e.id),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(cancelLabel),
        ),
      ],
    ),
  );
}

/// 進捗保存時に保存名を入力する共通ダイアログ。
/// OK時はトリム済みの文字列、キャンセル時は null を返す。
class SaveNameDialog extends StatefulWidget {
  const SaveNameDialog({
    super.key,
    required this.initial,
    required this.title,
    required this.hint,
    required this.okLabel,
    required this.cancelLabel,
  });

  final String initial;
  final String title;
  final String hint;
  final String okLabel;
  final String cancelLabel;

  @override
  State<SaveNameDialog> createState() => _SaveNameDialogState();
}

class _SaveNameDialogState extends State<SaveNameDialog> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        decoration: InputDecoration(hintText: widget.hint),
        onSubmitted: (v) => Navigator.pop(context, v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _ctrl.text.trim()),
          child: Text(widget.okLabel),
        ),
      ],
    );
  }
}
