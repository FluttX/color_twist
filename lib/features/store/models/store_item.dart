import 'package:color_twist/features/store/models/store_category.dart';
import 'package:equatable/equatable.dart';

class StoreItem extends Equatable {
  const StoreItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.isDefault = false,
    this.previewEmoji,
  });

  final String id;
  final String name;
  final String description;
  final int price;
  final StoreCategory category;
  final bool isDefault;
  final String? previewEmoji;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        category,
        isDefault,
        previewEmoji,
      ];
}
