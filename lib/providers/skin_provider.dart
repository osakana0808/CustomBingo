import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lottery_skin.dart';

class SkinNotifier extends Notifier<LotterySkin> {
  static const _key = 'lottery_skin';

  @override
  LotterySkin build() => LotterySkin.wooden;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      state = LotterySkin.values.firstWhere(
        (s) => s.name == saved,
        orElse: () => LotterySkin.wooden,
      );
    }
  }

  Future<void> setSkin(LotterySkin skin) async {
    state = skin;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, skin.name);
  }
}

final skinProvider =
    NotifierProvider<SkinNotifier, LotterySkin>(SkinNotifier.new);
