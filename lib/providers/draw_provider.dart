import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/draw_session.dart';

class DrawNotifier extends Notifier<DrawSession?> {
  @override
  DrawSession? build() => null;

  void start(String listId, List<String> items) {
    state = DrawSession(
      listId: listId,
      drawnItems: [],
      remaining: List.of(items)..shuffle(),
    );
  }

  void drawNext() {
    final session = state;
    if (session == null || session.isEmpty) return;
    state = session.draw();
  }

  /// 保存済みの進行状況を復元する
  void restore(DrawSession session) => state = session;

  void reset() => state = null;
}

final drawProvider =
    NotifierProvider<DrawNotifier, DrawSession?>(DrawNotifier.new);

/// 直近に保存した時点の抽選状態の署名。現在の署名と一致すれば「保存後に
/// 変更がない」とみなし、終了確認を省略できる。新規開始時は null にリセット。
final lastSavedSessionSignatureProvider = StateProvider<String?>((ref) => null);

/// 抽選の署名。抽選は追加のみなので件数で変化を判定できる。
String drawSignature(DrawSession session) =>
    '${session.listId}:${session.drawnItems.length}';
