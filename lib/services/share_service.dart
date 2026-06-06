import 'package:flutter/services.dart';
import '../models/bingo_item.dart';
import '../models/bingo_list.dart';

class ShareService {
  static String encode(BingoList list) {
    final words = list.items.map((i) => i.word).join(', ');
    return '[ビンゴリスト]\n'
        '名前: ${list.name}\n'
        '概要: ${list.description}\n'
        'フリーマス: ${list.hasFreeSpace ? 'あり' : 'なし'}\n'
        '\n'
        '$words';
  }

  static BingoList? decode(String text, String newId) {
    if (!text.contains('[ビンゴリスト]')) return null;
    final lines = text.split('\n');
    String name = '';
    String description = '';
    bool hasFreeSpace = true;
    List<String> words = [];

    bool pastHeader = false;
    for (final line in lines) {
      if (line.startsWith('名前:')) {
        name = line.substring(3).trim();
      } else if (line.startsWith('概要:')) {
        description = line.substring(3).trim();
      } else if (line.startsWith('フリーマス:')) {
        hasFreeSpace = line.contains('あり');
      } else if (pastHeader || (line.trim().isEmpty && name.isNotEmpty)) {
        if (line.trim().isNotEmpty) {
          pastHeader = true;
          words.addAll(
              line.split(',').map((w) => w.trim()).where((w) => w.isNotEmpty));
        }
      }
    }

    if (name.isEmpty || words.isEmpty) return null;

    return BingoList(
      id: newId,
      name: name,
      description: description,
      items: words
          .asMap()
          .entries
          .map((e) => BingoItem(id: '${newId}_item_${e.key}', word: e.value))
          .toList(),
      hasFreeSpace: hasFreeSpace,
    );
  }

  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static Future<String?> pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }
}
