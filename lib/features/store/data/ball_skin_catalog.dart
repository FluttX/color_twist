import 'package:color_twist/features/store/models/store_category.dart';
import 'package:color_twist/features/store/models/store_item.dart';

const ballSkinCatalog = [
  StoreItem(
    id: 'classic',
    name: 'Classic',
    description: 'Simple glow ball',
    price: 0,
    category: StoreCategory.ballSkin,
    isDefault: true,
  ),
  StoreItem(
    id: 'gradient',
    name: 'Gradient',
    description: 'Smooth color gradient',
    price: 150,
    category: StoreCategory.ballSkin,
    previewEmoji: '🎨',
  ),
  StoreItem(
    id: 'emoji',
    name: 'Emoji',
    description: 'Expressive emoji ball',
    price: 200,
    category: StoreCategory.ballSkin,
    previewEmoji: '⚽',
  ),
  StoreItem(
    id: 'neon',
    name: 'Neon',
    description: 'Bright neon glow',
    price: 250,
    category: StoreCategory.ballSkin,
    previewEmoji: '💡',
  ),
  StoreItem(
    id: 'galaxy',
    name: 'Galaxy',
    description: 'Cosmic starfield ball',
    price: 350,
    category: StoreCategory.ballSkin,
    previewEmoji: '🌌',
  ),
  StoreItem(
    id: 'fire',
    name: 'Fire',
    description: 'Flaming energy ball',
    price: 400,
    category: StoreCategory.ballSkin,
    previewEmoji: '🔥',
  ),
  StoreItem(
    id: 'rainbow',
    name: 'Rainbow',
    description: 'Full spectrum swirl',
    price: 500,
    category: StoreCategory.ballSkin,
    previewEmoji: '🌈',
  ),
];
