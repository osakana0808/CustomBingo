import 'bingo_item.dart';

class BingoList {
  final String id;
  final String name;
  final String description;
  final List<BingoItem> items;
  final bool hasFreeSpace;
  final bool isPreset;

  const BingoList({
    required this.id,
    required this.name,
    this.description = '',
    required this.items,
    this.hasFreeSpace = true,
    this.isPreset = false,
  });

  BingoList copyWith({
    String? id,
    String? name,
    String? description,
    List<BingoItem>? items,
    bool? hasFreeSpace,
    bool? isPreset,
  }) {
    return BingoList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      items: items ?? this.items,
      hasFreeSpace: hasFreeSpace ?? this.hasFreeSpace,
      isPreset: isPreset ?? this.isPreset,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'has_free_space': hasFreeSpace ? 1 : 0,
        'is_preset': isPreset ? 1 : 0,
      };

  @override
  bool operator ==(Object other) => other is BingoList && other.id == id;

  @override
  int get hashCode => id.hashCode;

  factory BingoList.fromMap(Map<String, dynamic> map, List<BingoItem> items) =>
      BingoList(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String? ?? '',
        items: items,
        hasFreeSpace: (map['has_free_space'] as int) == 1,
        isPreset: (map['is_preset'] as int) == 1,
      );
}
