import 'package:color_twist/core/services/player_progress_service.dart';

class CoinService {
  CoinService({PlayerProgressService? progressService})
      : _progressService = progressService ?? PlayerProgressService();

  final PlayerProgressService _progressService;

  Future<void> initialize() => _progressService.initialize();

  int get balance => _progressService.coins;

  bool canAfford(int amount) => _progressService.canAfford(amount);

  Future<void> addCoins(int amount) => _progressService.addCoins(amount);

  Future<bool> spendCoins(int amount) => _progressService.spendCoins(amount);
}
