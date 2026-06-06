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

  void reset() => state = null;
}

final drawProvider =
    NotifierProvider<DrawNotifier, DrawSession?>(DrawNotifier.new);
