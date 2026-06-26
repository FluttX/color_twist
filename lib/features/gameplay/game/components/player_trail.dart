import 'package:color_twist/features/gameplay/game/components/player.dart';
import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:flame/components.dart';

class PlayerTrail extends Component with HasGameReference<TwistColorGame> {
  PlayerTrail({required this.player});

  final Player player;

  @override
  void update(double dt) {
    super.update(dt);
    if (player.isOnGround) {
      return;
    }

    game.particleEffects.playTrailDrip(
      player.position.clone(),
      player.currentColor,
    );
  }
}
