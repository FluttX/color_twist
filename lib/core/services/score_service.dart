import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  ScoreService({SharedPreferences? preferences})
      : _preferences = preferences;

  static const _highScoreKey = 'high_score';

  SharedPreferences? _preferences;
  int _cachedHighScore = 0;

  Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
    _cachedHighScore = _preferences!.getInt(_highScoreKey) ?? 0;
  }

  int get highScore => _cachedHighScore;

  Future<int> getHighScore() async {
    await initialize();
    return _cachedHighScore;
  }

  Future<bool> trySaveHighScore(int score) async {
    await initialize();
    if (score <= _cachedHighScore) {
      return false;
    }
    _cachedHighScore = score;
    await _preferences!.setInt(_highScoreKey, score);
    return true;
  }
}
