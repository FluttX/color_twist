import 'package:color_twist/features/store/models/store_category.dart';
import 'package:color_twist/features/store/models/store_item.dart';

const explosionCatalog = [
  StoreItem(
    id: 'burst',
    name: 'Burst',
    description: 'Classic explosion burst',
    price: 0,
    category: StoreCategory.explosion,
    isDefault: true,
  ),
  StoreItem(
    id: 'shatter',
    name: 'Shatter',
    description: 'Glass shatter effect',
    price: 200,
    category: StoreCategory.explosion,
    previewEmoji: '💥',
  ),
  StoreItem(
    id: 'nova',
    name: 'Nova',
    description: 'Radiant nova blast',
    price: 300,
    category: StoreCategory.explosion,
    previewEmoji: '🌟',
  ),
];
