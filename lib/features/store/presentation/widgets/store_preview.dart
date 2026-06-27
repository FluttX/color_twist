import 'dart:math' as math;

import 'package:color_twist/core/theme/gameplay_theme.dart';
import 'package:color_twist/features/gameplay/game/cosmetics/ball_skin_renderer.dart';
import 'package:color_twist/features/store/models/store_category.dart';
import 'package:flutter/material.dart';

class StorePreview extends StatefulWidget {
  const StorePreview({
    super.key,
    required this.category,
    required this.theme,
    required this.previewItemId,
    this.equippedBallSkinId = 'classic',
  });

  final StoreCategory category;
  final GameplayTheme theme;
  final String previewItemId;
  final String equippedBallSkinId;

  @override
  State<StorePreview> createState() => _StorePreviewState();
}

class _StorePreviewState extends State<StorePreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: widget.theme.backgroundGradient,
        ),
        border: Border.all(color: widget.theme.accentColor.withValues(alpha: 0.4)),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _PreviewPainter(
              category: widget.category,
              previewItemId: widget.previewItemId,
              equippedBallSkinId: widget.equippedBallSkinId,
              theme: widget.theme,
              time: _controller.value * math.pi * 2,
            ),
          );
        },
      ),
    );
  }
}

class _PreviewPainter extends CustomPainter {
  _PreviewPainter({
    required this.category,
    required this.previewItemId,
    required this.equippedBallSkinId,
    required this.theme,
    required this.time,
  });

  final StoreCategory category;
  final String previewItemId;
  final String equippedBallSkinId;
  final GameplayTheme theme;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 8);
    final ballColor = theme.gameColors.first;

    if (category == StoreCategory.theme) {
      for (var i = 0; i < theme.parallaxBandColors.length; i++) {
        final x = size.width * (0.2 + i * 0.2);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(x, center.dy), width: 40, height: 60),
            const Radius.circular(8),
          ),
          Paint()..color = theme.parallaxBandColors[i],
        );
      }
      return;
    }

    if (category == StoreCategory.music) {
      final textPainter = TextPainter(
        text: const TextSpan(text: '🎵', style: TextStyle(fontSize: 48)),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        center - Offset(textPainter.width / 2, textPainter.height / 2),
      );
      return;
    }

    if (category == StoreCategory.trail) {
      _drawTrail(canvas, center, ballColor, previewItemId);
    }

    if (category == StoreCategory.explosion) {
      _drawExplosion(canvas, center, ballColor, previewItemId);
    }

    final skinId = category == StoreCategory.ballSkin
        ? previewItemId
        : equippedBallSkinId;

    BallSkinRenderer.render(
      canvas: canvas,
      skinId: skinId,
      color: ballColor,
      radius: 24,
      scaleX: 1,
      scaleY: 1,
      center: center,
      time: time,
    );
  }

  void _drawTrail(Canvas canvas, Offset center, Color color, String trailId) {
    switch (trailId) {
      case 'spark':
        for (var i = 0; i < 14; i++) {
          final angle = (i / 14) * math.pi * 2 + time;
          final dist = 28 + math.sin(time + i) * 8;
          final pos = center + Offset(math.cos(angle) * dist, math.sin(angle) * dist);
          canvas.drawCircle(
            pos,
            2 + (i % 3),
            Paint()..color = Colors.white.withValues(alpha: 0.5 + (i % 3) * 0.15),
          );
        }
      case 'comet':
        for (var i = 0; i < 8; i++) {
          final t = i / 8;
          final y = center.dy + 10 + t * 50 + math.sin(time + t * 3) * 4;
          final x = center.dx + math.sin(time * 0.5 + t) * 6;
          final alpha = (1 - t) * 0.7;
          canvas.drawCircle(
            Offset(x, y),
            4 * (1 - t * 0.5),
            Paint()..color = color.withValues(alpha: alpha),
          );
        }
      default:
        for (var i = 0; i < 6; i++) {
          final phase = (time + i * 0.8) % (math.pi * 2);
          final y = center.dy + 20 + (phase / (math.pi * 2)) * 45;
          final x = center.dx + math.sin(phase + i) * 10;
          canvas.drawCircle(
            Offset(x, y),
            3,
            Paint()..color = color.withValues(alpha: 0.6 - i * 0.06),
          );
        }
    }
  }

  void _drawExplosion(
    Canvas canvas,
    Offset center,
    Color color,
    String explosionId,
  ) {
    final count = switch (explosionId) {
      'shatter' => 16,
      'nova' => 10,
      _ => 12,
    };
    for (var i = 0; i < count; i++) {
      final angle = (i / count) * math.pi * 2 + time * 0.3;
      final dist = switch (explosionId) {
        'nova' => 20 + math.sin(time + i) * 12,
        'shatter' => 30 + (i % 3) * 8,
        _ => 24 + math.sin(time + i * 0.5) * 6,
      };
      final pos = center + Offset(math.cos(angle) * dist, math.sin(angle) * dist);
      final particleColor = explosionId == 'nova' && i.isEven ? Colors.white : color;
      canvas.drawCircle(
        pos,
        switch (explosionId) {
          'shatter' => 3 + (i % 4),
          'nova' => 5 + (i % 3),
          _ => 4,
        },
        Paint()..color = particleColor.withValues(alpha: 0.75),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PreviewPainter oldDelegate) {
    return oldDelegate.previewItemId != previewItemId ||
        oldDelegate.equippedBallSkinId != equippedBallSkinId ||
        oldDelegate.theme.id != theme.id ||
        oldDelegate.category != category ||
        oldDelegate.time != time;
  }
}
