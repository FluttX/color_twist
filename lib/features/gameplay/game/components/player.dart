import 'package:color_twist/features/gameplay/game/components/circle_rotator.dart';
import 'package:color_twist/features/gameplay/game/components/color_switcher.dart';
import 'package:color_twist/features/gameplay/game/components/player_trail.dart';
import 'package:color_twist/features/gameplay/game/cosmetics/ball_skin_renderer.dart';
import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent
    with HasGameReference<TwistColorGame>, CollisionCallbacks {
  Player({
    this.radius = 12.0,
    required super.position,
  }) : super(
          priority: 20,
          anchor: Anchor.center,
          size: Vector2.all(24),
        );

  final _velocity = Vector2.zero();

  final double radius;
  Color _color = Colors.white;

  bool _isOnGround = true;

  double _scaleX = 1.0;
  double _scaleY = 1.0;
  double _squashTimer = 0;
  double _squashDuration = 0;
  double _targetScaleX = 1.0;
  double _targetScaleY = 1.0;

  static const _jumpStretchX = 0.82;
  static const _jumpStretchY = 1.18;
  static const _jumpStretchDuration = 0.12;
  static const _landSquashX = 1.25;
  static const _landSquashY = 0.75;
  static const _landSquashDuration = 0.10;

  Color get currentColor => _color;
  bool get isOnGround => _isOnGround;

  double get _gravity => game.effectiveGravity;
  double get _jumpSpeed => game.effectiveJumpSpeed;

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox(
      radius: radius,
      collisionType: CollisionType.active,
    ));
    game.world.add(PlayerTrail(player: this));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateSquashStretch(dt);

    final wasOnGround = _isOnGround;

    position += _velocity * dt;

    final bottomY = positionOfAnchor(Anchor.bottomCenter).y;
    if (game.ground.isMounted && bottomY > game.ground.position.y) {
      if (!wasOnGround && _velocity.y > 0) {
        _triggerLandingSquash();
      }
      _velocity.setValues(0, 0);
      position = Vector2(0, game.ground.position.y - (height / 2));
      _isOnGround = true;
    } else {
      _velocity.y += _gravity * dt;
      _isOnGround = false;
    }
  }

  void _updateSquashStretch(double dt) {
    if (_squashTimer > 0) {
      _squashTimer -= dt;
      final t = (_squashTimer / _squashDuration).clamp(0.0, 1.0);
      _scaleX = _lerp(_targetScaleX, 1.0, 1 - t);
      _scaleY = _lerp(_targetScaleY, 1.0, 1 - t);
    } else {
      _scaleX = 1.0;
      _scaleY = 1.0;
    }
  }

  double _lerp(double from, double to, double t) => from + (to - from) * t;

  void _triggerJumpStretch() {
    _targetScaleX = _jumpStretchX;
    _targetScaleY = _jumpStretchY;
    _squashDuration = _jumpStretchDuration;
    _squashTimer = _jumpStretchDuration;
    _scaleX = _targetScaleX;
    _scaleY = _targetScaleY;
  }

  void _triggerLandingSquash() {
    _targetScaleX = _landSquashX;
    _targetScaleY = _landSquashY;
    _squashDuration = _landSquashDuration;
    _squashTimer = _landSquashDuration;
    _scaleX = _targetScaleX;
    _scaleY = _targetScaleY;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final center = (size / 2).toOffset();

    BallSkinRenderer.render(
      canvas: canvas,
      skinId: game.config.appearance.ballSkinId,
      color: _color,
      radius: radius,
      scaleX: _scaleX,
      scaleY: _scaleY,
      center: center,
      time: game.currentTime(),
    );
  }

  void jump() {
    _velocity.y = -_jumpSpeed;
    _triggerJumpStretch();
  }

  void applyRandomColor() {
    _changePlayerColorRandomly();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is CircleArc) {
      if (_color != other.color) {
        game.gameOver();
      } else {
        final rotator = other.parent;
        if (!rotator.hasPassed) {
          rotator.markPassed();
          game.incrementCombo();
        }
      }
      return;
    }

    final switcher = _resolveColorSwitcher(other);
    if (switcher != null) {
      game.collectColorSwitcher(switcher);
    }
  }

  ColorSwitcher? _resolveColorSwitcher(PositionComponent other) {
    if (other is ColorSwitcher) return other;
    if (other.parent is ColorSwitcher) {
      return other.parent as ColorSwitcher;
    }
    return null;
  }

  void _changePlayerColorRandomly() {
    final colors = game.gameColors;
    if (colors.isEmpty) return;
    if (colors.length == 1) {
      _color = colors.first;
      return;
    }
    var next = colors.random();
    while (next == _color) {
      next = colors.random();
    }
    _color = next;
  }
}
