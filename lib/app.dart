import 'package:flutter/material.dart';
import 'screens/list/list_screen.dart';
import 'screens/card/card_setup_screen.dart';
import 'screens/draw/draw_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final _screens = const [
    ListScreen(),
    CardSetupScreen(),
    DrawScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ビンゴメーカー',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.list),
              label: 'リスト',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view),
              label: 'カード',
            ),
            NavigationDestination(
              icon: Icon(Icons.casino),
              label: '抽選',
            ),
          ],
        ),
      ),
    );
  }
}
