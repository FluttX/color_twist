import 'package:color_twist/core/theme/gameplay_theme.dart';
import 'package:color_twist/features/store/models/store_category.dart';
import 'package:color_twist/features/store/services/store_service.dart';
import 'package:flutter/material.dart';

class StoreItemTile extends StatelessWidget {
  const StoreItemTile({
    super.key,
    required this.itemState,
    required this.category,
    required this.coinBalance,
    required this.onPurchase,
    required this.onEquip,
    required this.theme,
    this.onPreview,
    this.onPreviewMusic,
    this.isPreviewing = false,
  });

  final StoreItemState itemState;
  final StoreCategory category;
  final int coinBalance;
  final VoidCallback onPurchase;
  final VoidCallback onEquip;
  final VoidCallback? onPreview;
  final VoidCallback? onPreviewMusic;
  final GameplayTheme theme;
  final bool isPreviewing;

  @override
  Widget build(BuildContext context) {
    final item = itemState.item;
    final canBuy = !itemState.isOwned && coinBalance >= item.price;

    return Card(
      color: theme.cardSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: itemState.isEquipped
              ? theme.accentColor
              : isPreviewing
                  ? theme.accentColor.withValues(alpha: 0.5)
                  : theme.subtleBorderColor,
          width: itemState.isEquipped || isPreviewing ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPreview,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.gameColors.first.withValues(alpha: 0.3),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.previewEmoji ?? _defaultEmoji(category),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryTextColor,
                          ),
                    ),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: theme.secondaryTextColor,
                          ),
                    ),
                    if (itemState.isEquipped)
                      Text(
                        'Equipped',
                        style: TextStyle(
                          color: theme.accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else if (isPreviewing)
                      Text(
                        'Previewing',
                        style: TextStyle(
                          color: theme.accentColor.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              _buildAction(context, canBuy, item.price),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context, bool canBuy, int price) {
    if (itemState.isEquipped) {
      return Icon(
        Icons.check_circle,
        color: theme.isLightTheme ? Colors.green : Colors.greenAccent,
      );
    }
    if (itemState.isOwned) {
      return FilledButton(
        onPressed: onEquip,
        child: const Text('Equip'),
      );
    }
    if (category == StoreCategory.music && onPreviewMusic != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onPreviewMusic,
            icon: const Icon(Icons.play_circle_outline),
          ),
          FilledButton(
            onPressed: canBuy ? onPurchase : null,
            child: Text('$price'),
          ),
        ],
      );
    }
    return FilledButton(
      onPressed: canBuy ? onPurchase : null,
      child: Text('$price'),
    );
  }

  String _defaultEmoji(StoreCategory category) => switch (category) {
        StoreCategory.ballSkin => '⚪',
        StoreCategory.trail => '✨',
        StoreCategory.explosion => '💥',
        StoreCategory.theme => '🎨',
        StoreCategory.music => '🎵',
      };
}
