import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app.dart';
import 'providers/skin_provider.dart';
import 'services/purchase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  await PurchaseService.init();
  final container = ProviderContainer();
  await container.read(skinProvider.notifier).load();
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
