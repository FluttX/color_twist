import 'dart:math' as math;

import 'package:flutter/material.dart';

abstract final class BallSkinRenderer {
  static void render({
    required Canvas canvas,
    required String skinId,
    required Color color,
    required double radius,
    required double scaleX,
    required double scaleY,
    required Offset center,
    required double time,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scaleX, scaleY);
    canvas.translate(-center.dx, -center.dy);

    switch (skinId) {
      case 'gradient':
        _renderGradient(canvas, center, radius, color);
      case 'emoji':
        _renderEmoji(canvas, center, radius, color);
      case 'neon':
        _renderNeon(canvas, center, radius, color);
      case 'galaxy':
        _renderGalaxy(canvas, center, radius, color, time);
      case 'fire':
        _renderFire(canvas, center, radius, color, time);
      case 'rainbow':
        _renderRainbow(canvas, center, radius, color);
      default:
        _renderClassic(canvas, center, radius, color);
    }

    canvas.restore();
  }

  static void _renderClassic(Canvas canvas, Offset center, double radius, Color color) {
    canvas.drawCircle(
      center,
      radius * 1.5,
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(center, radius, Paint()..color = color);
  }

  static void _renderGradient(Canvas canvas, Offset center, double radius, Color color) {
    canvas.drawCircle(
      center,
      radius * 1.4,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.5),
            color.withValues(alpha: 0.1),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 1.4)),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Color.lerp(color, Colors.white, 0.4)!,
            color,
            Color.lerp(color, Colors.black, 0.3)!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  static void _renderEmoji(Canvas canvas, Offset center, double radius, Color color) {
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color.withValues(alpha: 0.35),
    );
    canvas.drawCircle(
      center,
      radius * 0.92,
      Paint()..color = color,
    );
    const emoji = '⚽';
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(fontSize: radius * 1.4),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  static void _renderNeon(Canvas canvas, Offset center, double radius, Color color) {
    for (var i = 3; i >= 1; i--) {
      canvas.drawCircle(
        center,
        radius * (1 + i * 0.25),
        Paint()
          ..color = color.withValues(alpha: 0.15 * i)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0 * i),
      );
    }
    canvas.drawCircle(center, radius, Paint()..color = color);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  static void _renderGalaxy(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double time,
  ) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.8),
            const Color(0xFF1A0A2E),
            const Color(0xFF0A0515),
          ],
          stops: const [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    final rng = math.Random(7);
    for (var i = 0; i < 12; i++) {
      final angle = rng.nextDouble() * math.pi * 2 + time * 0.5;
      final dist = rng.nextDouble() * radius * 0.7;
      final starPos = center + Offset(math.cos(angle) * dist, math.sin(angle) * dist);
      canvas.drawCircle(
        starPos,
        rng.nextDouble() * 1.2 + 0.4,
        Paint()..color = Colors.white.withValues(alpha: rng.nextDouble() * 0.6 + 0.2),
      );
    }
  }

  static void _renderFire(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double time,
  ) {
    final flicker = math.sin(time * 12) * 0.08 + 1.0;
    canvas.drawCircle(
      center,
      radius * 1.6 * flicker,
      Paint()
        ..color = const Color(0xFFFF4500).withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.yellow.withValues(alpha: 0.9),
            const Color(0xFFFF6600),
            Color.lerp(color, const Color(0xFFFF2200), 0.5)!,
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  static void _renderRainbow(Canvas canvas, Offset center, double radius, Color color) {
    canvas.drawCircle(
      center,
      radius * 1.5,
      Paint()
        ..color = color.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = SweepGradient(
          colors: const [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.indigo,
            Colors.purple,
            Colors.red,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }
}
