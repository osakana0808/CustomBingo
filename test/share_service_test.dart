import 'package:flutter_test/flutter_test.dart';
import 'package:custom_bingo/models/bingo_item.dart';
import 'package:custom_bingo/models/bingo_list.dart';
import 'package:custom_bingo/services/share_service.dart';

BingoList _list(List<String> words) => BingoList(
      id: 'src',
      name: 'テストリスト',
      description: '説明',
      items: words
          .asMap()
          .entries
          .map((e) => BingoItem(id: 'src_${e.key}', word: e.value))
          .toList(),
      hasFreeSpace: true,
    );

void main() {
  group('ShareService 改行往復', () {
    test('改行を含む単語がエクスポート→インポートで保持される', () {
      final list = _list(['東一局', '立直\n一発', '門前\n清\n自摸']);
      final encoded = ShareService.encode(list);
      // エクスポート文字列に生の改行が単語内に残っていないこと（フォーマット行は別）
      final body = encoded.split('\n\n').last;
      expect(body.contains('\\n'), isTrue);

      final decoded = ShareService.decode(encoded, 'dst');
      expect(decoded, isNotNull);
      expect(decoded!.items.map((i) => i.word).toList(),
          ['東一局', '立直\n一発', '門前\n清\n自摸']);
    });

    test('改行なしの既存データは従来通りエンコードされる（後方互換）', () {
      final list = _list(['A', 'B', 'C']);
      final encoded = ShareService.encode(list);
      expect(encoded.contains('A, B, C'), isTrue);
      expect(encoded.contains('\\n'), isFalse);

      final decoded = ShareService.decode(encoded, 'dst');
      expect(decoded!.items.map((i) => i.word).toList(), ['A', 'B', 'C']);
    });

    test('バックスラッシュを含む単語も往復で保持される', () {
      final list = _list(['back\\slash', 'line\nbreak']);
      final decoded = ShareService.decode(ShareService.encode(list), 'dst');
      expect(decoded!.items.map((i) => i.word).toList(),
          ['back\\slash', 'line\nbreak']);
    });
  });
}
