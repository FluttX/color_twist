import 'package:color_twist/features/store/models/store_category.dart';
import 'package:color_twist/features/store/models/store_item.dart';

const trailCatalog = [
  StoreItem(
    id: 'drip',
    name: 'Drip',
    description: 'Classic color drip trail',
    price: 0,
    category: StoreCategory.trail,
    isDefault: true,
  ),
  StoreItem(
    id: 'spark',
    name: 'Spark',
    description: 'Electric spark trail',
    price: 200,
    category: StoreCategory.trail,
    previewEmoji: '✨',
  ),
  StoreItem(
    id: 'comet',
    name: 'Comet',
    description: 'Long comet tail',
    price: 300,
    category: StoreCategory.trail,
    previewEmoji: '☄️',
  ),
];
