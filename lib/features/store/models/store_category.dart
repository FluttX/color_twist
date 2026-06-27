enum StoreCategory {
  ballSkin,
  trail,
  explosion,
  theme,
  music,
}

extension StoreCategoryX on StoreCategory {
  String get label => switch (this) {
        StoreCategory.ballSkin => 'Ball Skins',
        StoreCategory.trail => 'Trails',
        StoreCategory.explosion => 'Explosions',
        StoreCategory.theme => 'Themes',
        StoreCategory.music => 'Music',
      };
}
