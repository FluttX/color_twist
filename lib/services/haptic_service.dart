import 'package:flutter/services.dart';

class HapticService {
  void onJump() => HapticFeedback.lightImpact();

  void onCollect() => HapticFeedback.mediumImpact();

  void onGameOver() => HapticFeedback.heavyImpact();
}
