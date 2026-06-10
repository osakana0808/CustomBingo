import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../l10n/app_localizations.dart';
import '../../models/lottery_skin.dart';

class LotteryAnimationWidget extends StatefulWidget {
  const LotteryAnimationWidget({
    super.key,
    required this.item,
    required this.onComplete,
    this.skin = LotterySkin.wooden,
  });

  final String item;
  final VoidCallback onComplete;
  final LotterySkin skin;

  @override
  State<LotteryAnimationWidget> createState() => _LotteryAnimationWidgetState();
}

class _LotteryAnimationWidgetState extends State<LotteryAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // フェーズ区切り (0.0〜1.0) 全体2500ms
  static const _drumAppearEnd = 0.12;  // 0〜300ms  : 落下出現
  static const _drumSpinEnd   = 0.72;  // 300〜1800ms: 回転
  static const _ballEjectEnd  = 0.84;  // 1800〜2100ms: ボール射出
  static const _numberShowEnd = 1.0;   // 2100〜2500ms: 数字表示

  late final Animation<double> _drumOpacity;
  late final Animation<double> _drumSlide;
  late final Animation<double> _drumRotation; // 0 〜 6π (3回転)
  late final Animation<double> _ballProgress;
  late final Animation<double> _numberOpacity;
  late final Animation<double> _numberScale;

  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _drumOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, _drumAppearEnd, curve: Curves.easeOut),
      ),
    );

    _drumSlide = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, _drumAppearEnd, curve: Curves.easeOut),
      ),
    );

    _drumRotation = Tween(begin: 0.0, end: -pi * 6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(_drumAppearEnd, _drumSpinEnd, curve: Curves.easeInOut),
      ),
    );

    _ballProgress = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(_drumSpinEnd, _ballEjectEnd, curve: Curves.easeOut),
      ),
    );

    _numberOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(_ballEjectEnd, _numberShowEnd, curve: Curves.easeOut),
      ),
    );

    _numberScale = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(_ballEjectEnd, _numberShowEnd, curve: Curves.elasticOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_completed) {
        _completed = true;
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) widget.onComplete();
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _skip() {
    if (_completed) return;
    _completed = true;
    _controller.stop();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // ドラムのサイズ（画面幅の85%）
    final drumSize = screenSize.width * 0.85;

    // ドラム中心位置：画面上部35%
    final drumCenterX = screenSize.width / 2;
    final drumCenterY = screenSize.height * 0.35;

    // ボール射出：ドラムの右下（4〜5時方向）から右下へ飛び出す
    final ballOriginX = drumCenterX + drumSize * 0.32;
    final ballOriginY = drumCenterY + drumSize * 0.32;
    final ballEndX    = ballOriginX + screenSize.width * 0.11;
    final ballEndY    = ballOriginY + screenSize.height * 0.07;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _skip,
      child: Container(
        color: Colors.black.withValues(alpha: 0.78),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final currentDrumY = drumCenterY + _drumSlide.value * drumSize * 0.6;

            final ballX = ballOriginX + (ballEndX - ballOriginX) * _ballProgress.value;
            final ballY = ballOriginY + (ballEndY - ballOriginY) * _ballProgress.value;
            final ballVisible = _ballProgress.value > 0.0;

            return Stack(
              children: [
                // ─── ドラムホイール（落下＋回転、ハンドル含む） ───
                Positioned(
                  left: drumCenterX - drumSize / 2,
                  top:  currentDrumY - drumSize / 2,
                  child: Opacity(
                    opacity: _drumOpacity.value,
                    child: Transform.rotate(
                      angle: _drumRotation.value,
                      child: SvgPicture.asset(
                        widget.skin.assetPath,
                        width: drumSize,
                        height: drumSize,
                      ),
                    ),
                  ),
                ),

                // ─── ボール（右端から右下へ飛び出す） ───
                if (ballVisible)
                  Positioned(
                    left: ballX - 22,
                    top:  ballY - 22,
                    child: Opacity(
                      opacity: _ballProgress.value.clamp(0.0, 1.0),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: const Alignment(-0.3, -0.3),
                            colors: widget.skin.ballColors,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.skin.ballGlow.withValues(alpha: 0.6),
                              blurRadius: 14,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ─── 抽選結果カード ───
                if (_numberOpacity.value > 0)
                  Positioned.fill(
                    child: Align(
                      alignment: const Alignment(0, 0.55),
                      child: Opacity(
                        opacity: _numberOpacity.value,
                        child: Transform.scale(
                          scale: _numberScale.value,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: screenSize.width * 0.82,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36, vertical: 22),
                            decoration: BoxDecoration(
                              color: widget.skin.cardColor,
                              borderRadius: BorderRadius.circular(28),
                              border: widget.skin == LotterySkin.casino
                                  ? Border.all(
                                      color: const Color(0xFFD4AF37),
                                      width: 2,
                                    )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.skin.cardGlow.withValues(alpha: 0.5),
                                  blurRadius: 30,
                                  spreadRadius: 6,
                                ),
                              ],
                            ),
                            child: Text(
                              widget.item,
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: widget.skin.cardTextColor,
                                height: 1.1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // ─── スキップヒント ───
                if (_numberOpacity.value < 0.5)
                  Positioned(
                    bottom: 52,
                    left: 0,
                    right: 0,
                    child: Text(
                      AppLocalizations.of(context).drawSkip,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
