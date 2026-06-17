import '../models/bingo_item.dart';
import '../models/bingo_list.dart';

class ShareService {
  // エクスポート形式は英語で統一（世界中のユーザーで互換性が保たれる）
  static String encode(BingoList list) {
    // 単語内の改行は区切り（行・カンマ）と衝突するため、リテラル \n に
    // エスケープしてから連結する（インポート時に復元）
    final words = list.items.map((i) => _escape(i.word)).join(', ');
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
          words.addAll(line
              .split(',')
              .map((w) => _unescape(w.trim()))
              .where((w) => w.isNotEmpty));
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

  // 改行を含む単語を1行・カンマ区切り形式で安全に往復させるためのエスケープ。
  // バックスラッシュを先にエスケープし、その後で改行を \n に変換する。
  static String _escape(String word) =>
      word.replaceAll('\\', '\\\\').replaceAll('\r\n', '\n').replaceAll('\n', '\\n');

  static String _unescape(String word) {
    final buffer = StringBuffer();
    for (int i = 0; i < word.length; i++) {
      final ch = word[i];
      if (ch == '\\' && i + 1 < word.length) {
        final next = word[i + 1];
        if (next == 'n') {
          buffer.write('\n');
          i++;
          continue;
        } else if (next == '\\') {
          buffer.write('\\');
          i++;
          continue;
        }
      }
      buffer.write(ch);
    }
    return buffer.toString();
  }
}
