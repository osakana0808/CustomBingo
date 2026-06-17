import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/saved_draw_session.dart';
import '../services/draw_session_service.dart';

final drawSessionServiceProvider =
    Provider<DrawSessionService>((ref) => DrawSessionService());

final savedSessionsProvider =
    AsyncNotifierProvider<SavedSessionsNotifier, List<SavedDrawSession>>(
        SavedSessionsNotifier.new);

class SavedSessionsNotifier extends AsyncNotifier<List<SavedDrawSession>> {
  @override
  Future<List<SavedDrawSession>> build() {
    return ref.read(drawSessionServiceProvider).fetchAll();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(drawSessionServiceProvider).fetchAll());
  }

  Future<void> save(SavedDrawSession session) async {
    await ref.read(drawSessionServiceProvider).save(session);
    await reload();
  }

  Future<void> delete(String id) async {
    await ref.read(drawSessionServiceProvider).delete(id);
    await reload();
  }
}
