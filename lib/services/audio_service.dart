import 'package:color_twist/core/constants/asset_paths.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioService {
  String _currentTrack = AssetPaths.backgroundMusic;

  Future<void> initialize() async {
    await FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(AssetPaths.audio);
  }

  void playBackgroundMusic([String? trackPath]) {
    final track = trackPath ?? _currentTrack;
    _currentTrack = track;
    FlameAudio.bgm.play(track);
  }

  void setMusicTrack(String trackPath) {
    _currentTrack = trackPath;
    stopBackgroundMusic();
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
