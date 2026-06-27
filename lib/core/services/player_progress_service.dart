import 'package:shared_preferences/shared_preferences.dart';

class PlayerProgressService {
  PlayerProgressService({SharedPreferences? preferences})
      : _preferences = preferences;

  static const _coinsKey = 'coins';
  static const _totalStarsKey = 'total_stars';
  static const _totalJumpsKey = 'total_jumps';
  static const _totalColorChangesKey = 'total_color_changes';
  static const _gamesPlayedKey = 'games_played';
  static const _dailyDateKey = 'daily_date';
  static const _dailyChallengeIdKey = 'daily_challenge_id';
  static const _dailyProgressKey = 'daily_progress';
  static const _dailyCompleteKey = 'daily_complete';
  static const _dailyClaimedKey = 'daily_claimed';

  SharedPreferences? _preferences;

  int _coins = 0;
  int _totalStars = 0;
  int _totalJumps = 0;
  int _totalColorChanges = 0;
  int _gamesPlayed = 0;
  String _dailyDate = '';
  String _dailyChallengeId = '';
  int _dailyProgress = 0;
  bool _dailyComplete = false;
  bool _dailyClaimed = false;

  Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
    final prefs = _preferences!;

    _coins = prefs.getInt(_coinsKey) ?? 0;
    _totalStars = prefs.getInt(_totalStarsKey) ?? 0;
    _totalJumps = prefs.getInt(_totalJumpsKey) ?? 0;
    _totalColorChanges = prefs.getInt(_totalColorChangesKey) ?? 0;
    _gamesPlayed = prefs.getInt(_gamesPlayedKey) ?? 0;
    _dailyDate = prefs.getString(_dailyDateKey) ?? '';
    _dailyChallengeId = prefs.getString(_dailyChallengeIdKey) ?? '';
    _dailyProgress = prefs.getInt(_dailyProgressKey) ?? 0;
    _dailyComplete = prefs.getBool(_dailyCompleteKey) ?? false;
    _dailyClaimed = prefs.getBool(_dailyClaimedKey) ?? false;
  }

  int get coins => _coins;
  int get totalStars => _totalStars;
  int get totalJumps => _totalJumps;
  int get totalColorChanges => _totalColorChanges;
  int get gamesPlayed => _gamesPlayed;
  String get dailyDate => _dailyDate;
  String get dailyChallengeId => _dailyChallengeId;
  int get dailyProgress => _dailyProgress;
  bool get dailyComplete => _dailyComplete;
  bool get dailyClaimed => _dailyClaimed;

  Future<void> addCoins(int amount) async {
    if (amount <= 0) return;
    await initialize();
    _coins += amount;
    await _preferences!.setInt(_coinsKey, _coins);
  }

  Future<void> incrementLifetimeStats({
    required int stars,
    required int jumps,
    required int colorChanges,
    required int games,
  }) async {
    await initialize();
    _totalStars += stars;
    _totalJumps += jumps;
    _totalColorChanges += colorChanges;
    _gamesPlayed += games;

    await _preferences!.setInt(_totalStarsKey, _totalStars);
    await _preferences!.setInt(_totalJumpsKey, _totalJumps);
    await _preferences!.setInt(_totalColorChangesKey, _totalColorChanges);
    await _preferences!.setInt(_gamesPlayedKey, _gamesPlayed);
  }

  Future<void> setDailyState({
    required String date,
    required String challengeId,
    required int progress,
    required bool complete,
    required bool claimed,
  }) async {
    await initialize();
    _dailyDate = date;
    _dailyChallengeId = challengeId;
    _dailyProgress = progress;
    _dailyComplete = complete;
    _dailyClaimed = claimed;

    await _preferences!.setString(_dailyDateKey, _dailyDate);
    await _preferences!.setString(_dailyChallengeIdKey, _dailyChallengeId);
    await _preferences!.setInt(_dailyProgressKey, _dailyProgress);
    await _preferences!.setBool(_dailyCompleteKey, _dailyComplete);
    await _preferences!.setBool(_dailyClaimedKey, _dailyClaimed);
  }

  Future<int> getMissionProgress(String missionId) async {
    await initialize();
    return _preferences!.getInt(_missionProgressKey(missionId)) ?? 0;
  }

  Future<bool> isMissionClaimed(String missionId) async {
    await initialize();
    return _preferences!.getBool(_missionClaimedKey(missionId)) ?? false;
  }

  Future<void> setMissionProgress(String missionId, int progress) async {
    await initialize();
    await _preferences!.setInt(_missionProgressKey(missionId), progress);
  }

  Future<void> setMissionClaimed(String missionId, bool claimed) async {
    await initialize();
    await _preferences!.setBool(_missionClaimedKey(missionId), claimed);
  }

  Future<bool> isAchievementUnlocked(String achievementId) async {
    await initialize();
    return _preferences!.getBool(_achievementKey(achievementId)) ?? false;
  }

  Future<void> setAchievementUnlocked(String achievementId, bool unlocked) async {
    await initialize();
    await _preferences!.setBool(_achievementKey(achievementId), unlocked);
  }

  String _missionProgressKey(String id) => 'mission_${id}_progress';
  String _missionClaimedKey(String id) => 'mission_${id}_claimed';
  String _achievementKey(String id) => 'achievement_${id}_unlocked';
}
