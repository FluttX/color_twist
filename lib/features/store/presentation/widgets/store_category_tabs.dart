import 'package:color_twist/features/store/models/store_category.dart';
import 'package:flutter/material.dart';

class StoreCategoryTabs extends StatelessWidget {
  const StoreCategoryTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final StoreCategory selected;
  final ValueChanged<StoreCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: StoreCategory.values.map((category) {
          final isSelected = category == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(category.label),
              selected: isSelected,
              onSelected: (_) => onSelected(category),
            ),
          );
        }).toList(),
      ),
    );
  }
}
