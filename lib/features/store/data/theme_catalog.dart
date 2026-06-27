import 'package:color_twist/features/store/models/store_category.dart';
import 'package:color_twist/features/store/models/store_item.dart';

const themeCatalog = [
  StoreItem(
    id: 'dark',
    name: 'Dark',
    description: 'Classic dark theme',
    price: 0,
    category: StoreCategory.theme,
    isDefault: true,
  ),
  StoreItem(
    id: 'neon',
    name: 'Neon',
    description: 'Vibrant neon colors',
    price: 300,
    category: StoreCategory.theme,
    previewEmoji: '🌃',
  ),
  StoreItem(
    id: 'space',
    name: 'Space',
    description: 'Deep space vibes',
    price: 350,
    category: StoreCategory.theme,
    previewEmoji: '🚀',
  ),
  StoreItem(
    id: 'cyberpunk',
    name: 'Cyberpunk',
    description: 'Futuristic cyber aesthetic',
    price: 400,
    category: StoreCategory.theme,
    previewEmoji: '🤖',
  ),
  StoreItem(
    id: 'pastel',
    name: 'Pastel',
    description: 'Soft pastel palette',
    price: 350,
    category: StoreCategory.theme,
    previewEmoji: '🌸',
  ),
  StoreItem(
    id: 'halloween',
    name: 'Halloween',
    description: 'Spooky seasonal theme',
    price: 450,
    category: StoreCategory.theme,
    previewEmoji: '🎃',
  ),
  StoreItem(
    id: 'winter',
    name: 'Winter',
    description: 'Icy winter wonderland',
    price: 500,
    category: StoreCategory.theme,
    previewEmoji: '❄️',
  ),
];
