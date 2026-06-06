class BingoItem {
  final String id;
  final String word;
  final String? column;

  const BingoItem({
    required this.id,
    required this.word,
    this.column,
  });

  BingoItem copyWith({String? id, String? word, String? column}) {
    return BingoItem(
      id: id ?? this.id,
      word: word ?? this.word,
      column: column ?? this.column,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'word': word,
        'col': column,
      };

  factory BingoItem.fromMap(Map<String, dynamic> map) => BingoItem(
        id: map['id'] as String,
        word: map['word'] as String,
        column: map['col'] as String?,
      );
}
