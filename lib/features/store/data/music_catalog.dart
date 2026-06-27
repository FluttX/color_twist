import 'package:color_twist/features/store/models/store_category.dart';
import 'package:color_twist/features/store/models/store_item.dart';

const musicCatalog = [
  StoreItem(
    id: 'default',
    name: 'Classic',
    description: 'Original background track',
    price: 0,
    category: StoreCategory.music,
    isDefault: true,
  ),
  StoreItem(
    id: 'ambient',
    name: 'Ambient',
    description: 'Calm ambient vibes',
    price: 300,
    category: StoreCategory.music,
    previewEmoji: '🎵',
  ),
  StoreItem(
    id: 'upbeat',
    name: 'Upbeat',
    description: 'Energetic rhythm',
    price: 350,
    category: StoreCategory.music,
    previewEmoji: '🎶',
  ),
  StoreItem(
    id: 'chill',
    name: 'Chill',
    description: 'Relaxed lo-fi feel',
    price: 400,
    category: StoreCategory.music,
    previewEmoji: '🎧',
  ),
];

String musicTrackPath(String musicId) => switch (musicId) {
      'ambient' => 'ambient.mp3',
      'upbeat' => 'upbeat.mp3',
      'chill' => 'chill.mp3',
      _ => 'background.mp3',
    };
