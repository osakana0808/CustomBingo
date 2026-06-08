import '../models/bingo_item.dart';
import '../models/bingo_list.dart';

class ShareService {
  // エクスポート形式は英語で統一（世界中のユーザーで互換性が保たれる）
  static String encode(BingoList list) {
    final words = list.items.map((i) => i.word).join(', ');
    return '[BingoList]\n'
        'name: ${list.name}\n'
        'description: ${list.description}\n'
        'freeSpace: ${list.hasFreeSpace ? 'yes' : 'no'}\n'
        '\n'
        '$words';
  }

  static BingoList? decode(String text, String newId) {
    if (!text.contains('[BingoList]')) return null;

    final lines = text.split('\n');
    String name = '';
    String description = '';
    bool hasFreeSpace = true;
    List<String> words = [];

    bool pastHeader = false;
    for (final line in lines) {
      if (line.startsWith('name:')) {
        name = line.substring(5).trim();
      } else if (line.startsWith('description:')) {
        description = line.substring(12).trim();
      } else if (line.startsWith('freeSpace:')) {
        hasFreeSpace = line.contains('yes');
      } else if (pastHeader || (line.trim().isEmpty && name.isNotEmpty)) {
        pastHeader = true;
        if (line.trim().isNotEmpty) {
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
}
