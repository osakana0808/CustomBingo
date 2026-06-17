import 'package:flutter_test/flutter_test.dart';
import 'package:custom_bingo/models/saved_draw_session.dart';

void main() {
  group('SavedDrawSession', () {
    final session = SavedDrawSession(
      id: 'sid',
      name: '麻雀の続き',
      listId: 'lid',
      listName: '麻雀',
      drawnItems: ['東', '南\n二局'],
      remaining: ['西', '北'],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(1700000000000),
    );

    test('toMap → fromMap で往復する（改行を含む単語も保持）', () {
      final restored = SavedDrawSession.fromMap(session.toMap());
      expect(restored.id, 'sid');
      expect(restored.name, '麻雀の続き');
      expect(restored.listId, 'lid');
      expect(restored.listName, '麻雀');
      expect(restored.drawnItems, ['東', '南\n二局']);
      expect(restored.remaining, ['西', '北']);
      expect(restored.updatedAt, session.updatedAt);
    });

    test('toDrawSession で再開用の DrawSession に変換できる', () {
      final draw = session.toDrawSession();
      expect(draw.listId, 'lid');
      expect(draw.drawnItems, ['東', '南\n二局']);
      expect(draw.remaining, ['西', '北']);
      expect(draw.lastDrawn, '南\n二局');
    });

    test('空配列も往復で保持される', () {
      final empty = SavedDrawSession(
        id: 'e',
        name: 'n',
        listId: 'l',
        listName: '',
        drawnItems: const [],
        remaining: const [],
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      );
      final restored = SavedDrawSession.fromMap(empty.toMap());
      expect(restored.drawnItems, isEmpty);
      expect(restored.remaining, isEmpty);
    });
  });
}
