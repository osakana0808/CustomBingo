import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/saved_bingo_card.dart';
import '../services/card_save_service.dart';

final cardSaveServiceProvider =
    Provider<CardSaveService>((ref) => CardSaveService());

final savedCardsProvider =
    AsyncNotifierProvider<SavedCardsNotifier, List<SavedBingoCard>>(
        SavedCardsNotifier.new);

class SavedCardsNotifier extends AsyncNotifier<List<SavedBingoCard>> {
  @override
  Future<List<SavedBingoCard>> build() {
    return ref.read(cardSaveServiceProvider).fetchAll();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(cardSaveServiceProvider).fetchAll());
  }

  Future<void> save(SavedBingoCard card) async {
    await ref.read(cardSaveServiceProvider).save(card);
    await reload();
  }

  Future<void> delete(String id) async {
    await ref.read(cardSaveServiceProvider).delete(id);
    await reload();
  }
}
