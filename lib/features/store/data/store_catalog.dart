import 'package:color_twist/features/store/data/ball_skin_catalog.dart';
import 'package:color_twist/features/store/data/explosion_catalog.dart';
import 'package:color_twist/features/store/data/music_catalog.dart';
import 'package:color_twist/features/store/data/theme_catalog.dart';
import 'package:color_twist/features/store/data/trail_catalog.dart';
import 'package:color_twist/features/store/models/store_category.dart';
import 'package:color_twist/features/store/models/store_item.dart';

const storeCatalog = [
  ...ballSkinCatalog,
  ...trailCatalog,
  ...explosionCatalog,
  ...themeCatalog,
  ...musicCatalog,
];

StoreItem? storeItemById(String id) {
  for (final item in storeCatalog) {
    if (item.id == id) return item;
  }
  return null;
}

List<StoreItem> storeItemsForCategory(StoreCategory category) {
  return storeCatalog.where((item) => item.category == category).toList();
}

const defaultOwnedItemIds = {
  'classic',
  'drip',
  'burst',
  'dark',
  'default',
};
