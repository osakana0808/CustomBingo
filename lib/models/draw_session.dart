class DrawSession {
  final String listId;
  final List<String> drawnItems;
  final List<String> remaining;

  const DrawSession({
    required this.listId,
    required this.drawnItems,
    required this.remaining,
  });

  DrawSession draw() {
    if (remaining.isEmpty) return this;
    final shuffled = List<String>.from(remaining)..shuffle();
    final next = shuffled.first;
    return DrawSession(
      listId: listId,
      drawnItems: [...drawnItems, next],
      remaining: shuffled.sublist(1),
    );
  }

  bool get isEmpty => remaining.isEmpty;
  String? get lastDrawn => drawnItems.isEmpty ? null : drawnItems.last;
}
