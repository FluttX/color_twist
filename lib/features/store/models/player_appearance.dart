import 'package:equatable/equatable.dart';

class PlayerAppearance extends Equatable {
  const PlayerAppearance({
    this.ballSkinId = 'classic',
    this.trailId = 'drip',
    this.explosionId = 'burst',
  });

  final String ballSkinId;
  final String trailId;
  final String explosionId;

  PlayerAppearance copyWith({
    String? ballSkinId,
    String? trailId,
    String? explosionId,
  }) {
    return PlayerAppearance(
      ballSkinId: ballSkinId ?? this.ballSkinId,
      trailId: trailId ?? this.trailId,
      explosionId: explosionId ?? this.explosionId,
    );
  }

  @override
  List<Object?> get props => [ballSkinId, trailId, explosionId];
}
