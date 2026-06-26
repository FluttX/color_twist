import 'dart:math' as math;

import 'package:flutter/material.dart';

class GameplayParallaxBackground extends StatelessWidget {
  const GameplayParallaxBackground({
    super.key,
    required this.cameraYListenable,
    required this.driftListenable,
  });

  final Listenable cameraYListenable;
  final Listenable driftListenable;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([cameraYListenable, driftListenable]),
      builder: (context, _) {
        final cameraY = (cameraYListenable as ValueNotifier<double>).value;
        final drift = (driftListenable as ValueNotifier<double>).value;

        return CustomPaint(
          painter: _ParallaxPainter(
            cameraY: cameraY,
            drift: drift,
          ),
          size: MediaQuery.sizeOf(context),
        );
      },
    );
  }
}

class _ParallaxPainter extends CustomPainter {
  _ParallaxPainter({
    required this.cameraY,
    required this.drift,
  }) : _stars = _buildStars(),
       _bands = _buildBands();

  final double cameraY;
  final double drift;
  final List<_Star> _stars;
  final List<_BgBand> _bands;

  static const _tileHeight = 1200.0;
  static const _bandColors = [
    Color(0x18E94560),
    Color(0x1800ADB5),
    Color(0x18FFC947),
    Color(0x184833D4),
  ];

  static List<_Star> _buildStars() {
    final rng = math.Random(42);
    return List.generate(70, (_) {
      return _Star(
        x: rng.nextDouble(),
        y: rng.nextDouble() * 4 - 2,
        radius: rng.nextDouble() * 2.2 + 0.4,
        parallax: rng.nextDouble() * 0.45 + 0.15,
        opacity: rng.nextDouble() * 0.35 + 0.08,
      );
    });
  }

  static List<_BgBand> _buildBands() {
    final rng = math.Random(7);
    return List.generate(12, (i) {
      return _BgBand(
        x: rng.nextDouble(),
        y: rng.nextDouble() * 4 - 2,
        width: rng.nextDouble() * 120 + 40,
        height: rng.nextDouble() * 280 + 120,
        color: _bandColors[i % _bandColors.length],
        parallax: rng.nextDouble() * 0.25 + 0.05,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1B1B2F),
            Color(0xFF141428),
            Color(0xFF0C0C18),
          ],
        ).createShader(rect),
    );

    for (final band in _bands) {
      final scrollY =
          band.y * _tileHeight - cameraY * band.parallax + drift * band.parallax;
      final y = _wrapY(scrollY, size.height);
      final x = band.x * size.width;
      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y),
          width: band.width,
          height: band.height,
        ),
        const Radius.circular(24),
      );
      canvas.drawRRect(rrect, Paint()..color = band.color);
    }

    for (final star in _stars) {
      final scrollY =
          star.y * _tileHeight - cameraY * star.parallax + drift * 0.08;
      final y = _wrapY(scrollY, size.height);
      final x = star.x * size.width;
      canvas.drawCircle(
        Offset(x, y),
        star.radius,
        Paint()..color = Colors.white.withValues(alpha: star.opacity),
      );
    }

    _drawGrid(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    const spacing = 80.0;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    final offsetY = (cameraY * 0.35) % spacing;
    for (var y = -spacing; y <= size.height + spacing; y += spacing) {
      canvas.drawLine(
        Offset(0, y + offsetY),
        Offset(size.width, y + offsetY),
        paint,
      );
    }
  }

  double _wrapY(double y, double viewHeight) {
    var wrapped = y % _tileHeight;
    if (wrapped < 0) wrapped += _tileHeight;
    while (wrapped > viewHeight + _tileHeight / 2) {
      wrapped -= _tileHeight;
    }
    while (wrapped < -_tileHeight / 2) {
      wrapped += _tileHeight;
    }
    return wrapped;
  }

  @override
  bool shouldRepaint(covariant _ParallaxPainter oldDelegate) {
    return oldDelegate.cameraY != cameraY || oldDelegate.drift != drift;
  }
}

class _Star {
  _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.parallax,
    required this.opacity,
  });

  final double x;
  final double y;
  final double radius;
  final double parallax;
  final double opacity;
}

class _BgBand {
  _BgBand({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.color,
    required this.parallax,
  });

  final double x;
  final double y;
  final double width;
  final double height;
  final Color color;
  final double parallax;
}
