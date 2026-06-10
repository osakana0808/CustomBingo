import 'package:flutter/material.dart';

enum LotterySkin {
  wooden,
  casino;

  String get assetPath {
    switch (this) {
      case LotterySkin.wooden:
        return 'assets/images/lottery_drum_wheel.svg';
      case LotterySkin.casino:
        return 'assets/images/lottery_drum_casino.svg';
    }
  }

  // ボールの色
  List<Color> get ballColors {
    switch (this) {
      case LotterySkin.wooden:
        return [Colors.white, const Color(0xFFFFD54F), const Color(0xFFF57C00)];
      case LotterySkin.casino:
        return [Colors.white, const Color(0xFFFF6080), const Color(0xFFCC0030)];
    }
  }

  Color get ballGlow {
    switch (this) {
      case LotterySkin.wooden:
        return Colors.orange;
      case LotterySkin.casino:
        return const Color(0xFFCC0030);
    }
  }

  // 結果カードのスタイル
  Color get cardColor {
    switch (this) {
      case LotterySkin.wooden:
        return Colors.white;
      case LotterySkin.casino:
        return const Color(0xFF0A0E1E);
    }
  }

  Color get cardTextColor {
    switch (this) {
      case LotterySkin.wooden:
        return const Color(0xFF4A148C);
      case LotterySkin.casino:
        return const Color(0xFFD4AF37);
    }
  }

  Color get cardGlow {
    switch (this) {
      case LotterySkin.wooden:
        return Colors.amber;
      case LotterySkin.casino:
        return const Color(0xFFD4AF37);
    }
  }
}
