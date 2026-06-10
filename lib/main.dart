import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'providers/skin_provider.dart';
import 'services/purchase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PurchaseService.init();
  final container = ProviderContainer();
  await container.read(skinProvider.notifier).load();
  runApp(ProviderScope(parent: container, child: const App()));
}
