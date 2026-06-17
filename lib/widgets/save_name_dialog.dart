import 'package:flutter/material.dart';

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
