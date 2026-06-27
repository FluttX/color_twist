import 'package:color_twist/core/debug/developer_options.dart';
import 'package:color_twist/core/services/coin_service.dart';
import 'package:color_twist/core/services/player_progress_service.dart';
import 'package:color_twist/core/theme/gameplay_theme.dart';
import 'package:color_twist/features/store/data/music_catalog.dart';
import 'package:color_twist/features/store/data/store_catalog.dart';
import 'package:color_twist/features/store/models/player_appearance.dart';
import 'package:color_twist/features/store/models/store_category.dart';
import 'package:color_twist/features/store/models/store_item.dart';

class StoreService {
  StoreService._({
    required PlayerProgressService progress,
    required CoinService coins,
  })  : _progress = progress,
        _coins = coins;

  factory StoreService({
    PlayerProgressService? progressService,
    CoinService? coinService,
  }) {
    final progress = progressService ?? PlayerProgressService();
    return StoreService._(
      progress: progress,
      coins: coinService ?? CoinService(progressService: progress),
    );
  }

  final PlayerProgressService _progress;
  final CoinService _coins;

  Future<void> initialize() async {
    await _progress.initialize();
    await _coins.initialize();
    await _ensureDefaultsOwned();
  }

  int get coinBalance => _coins.balance;

  bool get _devUnlockAll => DeveloperOptions.unlockAllStoreItems;

  Future<void> _ensureDefaultsOwned() async {
    for (final id in defaultOwnedItemIds) {
      if (!_progress.isItemOwned(id)) {
        await _progress.addOwnedItem(id);
      }
    }
  }

  Future<bool> isOwned(String itemId) async {
    await initialize();
    if (_devUnlockAll) return true;
    final item = storeItemById(itemId);
    if (item?.isDefault == true) return true;
    return _progress.isItemOwned(itemId);
  }

  Future<bool> purchase(String itemId) async {
    await initialize();
    final item = storeItemById(itemId);
    if (item == null) return false;
    if (item.isDefault || _progress.isItemOwned(itemId)) return true;
    if (_devUnlockAll) {
      await _progress.addOwnedItem(itemId);
      return true;
    }
    if (!_coins.canAfford(item.price)) return false;

    final spent = await _coins.spendCoins(item.price);
    if (!spent) return false;

    await _progress.addOwnedItem(itemId);
    return true;
  }

  Future<bool> equip(String itemId) async {
    await initialize();
    final item = storeItemById(itemId);
    if (item == null) return false;
    if (!_devUnlockAll &&
        !item.isDefault &&
        !_progress.isItemOwned(itemId)) {
      return false;
    }

    switch (item.category) {
      case StoreCategory.ballSkin:
        await _progress.setEquippedBallSkin(itemId);
      case StoreCategory.trail:
        await _progress.setEquippedTrail(itemId);
      case StoreCategory.explosion:
        await _progress.setEquippedExplosion(itemId);
      case StoreCategory.theme:
        await _progress.setEquippedTheme(itemId);
      case StoreCategory.music:
        await _progress.setEquippedMusic(itemId);
    }
    return true;
  }

  Future<String> getEquipped(StoreCategory category) async {
    await initialize();
    return switch (category) {
      StoreCategory.ballSkin => _progress.equippedBallSkin,
      StoreCategory.trail => _progress.equippedTrail,
      StoreCategory.explosion => _progress.equippedExplosion,
      StoreCategory.theme => _progress.equippedTheme,
      StoreCategory.music => _progress.equippedMusic,
    };
  }

  Future<PlayerAppearance> loadAppearance() async {
    await initialize();
    return PlayerAppearance(
      ballSkinId: _progress.equippedBallSkin,
      trailId: _progress.equippedTrail,
      explosionId: _progress.equippedExplosion,
    );
  }

  Future<GameplayTheme> loadTheme() async {
    await initialize();
    return GameplayTheme.byId(_progress.equippedTheme);
  }

  Future<String> loadMusicTrackPath() async {
    await initialize();
    return musicTrackPath(_progress.equippedMusic);
  }

  Future<List<StoreItemState>> loadCategoryItems(StoreCategory category) async {
    await initialize();
    final equippedId = await getEquipped(category);
    final items = storeItemsForCategory(category);
    final states = <StoreItemState>[];

    for (final item in items) {
      final owned = _devUnlockAll ||
          item.isDefault ||
          _progress.isItemOwned(item.id);
      states.add(
        StoreItemState(
          item: item,
          isOwned: owned,
          isEquipped: item.id == equippedId,
        ),
      );
    }
    return states;
  }
}

class StoreItemState {
  const StoreItemState({
    required this.item,
    required this.isOwned,
    required this.isEquipped,
  });

  final StoreItem item;
  final bool isOwned;
  final bool isEquipped;
}
