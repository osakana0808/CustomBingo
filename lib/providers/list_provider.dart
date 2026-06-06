import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bingo_list.dart';
import '../services/list_service.dart';

final listServiceProvider = Provider<ListService>((ref) => ListService());

final bingoListsProvider =
    AsyncNotifierProvider<BingoListsNotifier, List<BingoList>>(
        BingoListsNotifier.new);

class BingoListsNotifier extends AsyncNotifier<List<BingoList>> {
  @override
  Future<List<BingoList>> build() async {
    final service = ref.read(listServiceProvider);
    await service.init();
    return service.fetchAll();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(listServiceProvider).fetchAll());
  }

  Future<void> save(BingoList list) async {
    await ref.read(listServiceProvider).save(list);
    await reload();
  }

  Future<void> delete(String id) async {
    await ref.read(listServiceProvider).delete(id);
    await reload();
  }
}
