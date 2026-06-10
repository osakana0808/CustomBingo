import '../models/bingo_item.dart';
import '../models/bingo_list.dart';

class Presets {
  static List<BingoList> get all => [
        _numbers,
        _hiragana,
        _alphabet,
        _mahjong,
      ];

  static BingoList get _numbers => _make(
        id: 'preset_numbers',
        name: '数字ビンゴ',
        description: '1〜75の数字',
        words: List.generate(75, (i) => '${i + 1}'),
        hasFreeSpace: true,
      );

  static BingoList get _hiragana => _make(
        id: 'preset_hiragana',
        name: 'ひらがな',
        description: 'あ〜ん（46文字）',
        words: const [
          'あ', 'い', 'う', 'え', 'お',
          'か', 'き', 'く', 'け', 'こ',
          'さ', 'し', 'す', 'せ', 'そ',
          'た', 'ち', 'つ', 'て', 'と',
          'な', 'に', 'ぬ', 'ね', 'の',
          'は', 'ひ', 'ふ', 'へ', 'ほ',
          'ま', 'み', 'む', 'め', 'も',
          'や', 'ゆ', 'よ',
          'ら', 'り', 'る', 'れ', 'ろ',
          'わ', 'を', 'ん',
        ],
        hasFreeSpace: true,
      );

  static BingoList get _alphabet => _make(
        id: 'preset_alphabet',
        name: 'アルファベット',
        description: 'A〜Z',
        words: List.generate(26, (i) => String.fromCharCode('A'.codeUnitAt(0) + i)),
        hasFreeSpace: true,
      );

  static BingoList get _mahjong => _make(
        id: 'preset_mahjong',
        name: '麻雀の役',
        description: '麻雀の役一覧',
        words: const [
          // 1翻
          '立直', '一発', '門前清自摸和', '平和', '一盃口',
          '断么九', '役牌', '混全帯么九', '嶺上開花', '槍槓',
          '海底摸月', '河底撈魚',
          // 2翻
          '七対子', '対々和', '三暗刻', '三槓子', '三色同順',
          '三色同刻', '一気通貫', '小三元', '混老頭',
          // 3翻
          '二盃口', '純全帯么九', '混一色',
          // 6翻
          '清一色',
          // 役満
          '国士無双', '九蓮宝燈', '四暗刻', '大三元',
          '小四喜', '大四喜', '字一色', '緑一色', '清老頭',
          '四槓子', '天和', '地和', '人和',
        ],
        hasFreeSpace: true,
      );

  static BingoList _make({
    required String id,
    required String name,
    required String description,
    required List<String> words,
    required bool hasFreeSpace,
  }) {
    return BingoList(
      id: id,
      name: name,
      description: description,
      items: words
          .asMap()
          .entries
          .map((e) => BingoItem(id: '${id}_${e.key}', word: e.value))
          .toList(),
      hasFreeSpace: hasFreeSpace,
      isPreset: true,
    );
  }
}
