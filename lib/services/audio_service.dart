import 'package:color_twist/core/constants/asset_paths.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioService {
  Future<void> initialize() async {
    await FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(AssetPaths.audio);
  }

  void playBackgroundMusic() {
    FlameAudio.bgm.play(AssetPaths.backgroundMusic);
  }

  void pauseBackgroundMusic() {
    FlameAudio.bgm.pause();
  }

  void resumeBackgroundMusic() {
    FlameAudio.bgm.resume();
  }

  void stopBackgroundMusic() {
    FlameAudio.bgm.stop();
  }

  void playCollectSound() {
    FlameAudio.play(AssetPaths.collectSound);
  }
}
