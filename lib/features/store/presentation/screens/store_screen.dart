import 'package:color_twist/app/app_services.dart';
import 'package:color_twist/core/debug/developer_options.dart';
import 'package:color_twist/core/theme/app_theme.dart';
import 'package:color_twist/core/theme/gameplay_theme.dart';
import 'package:color_twist/features/home/presentation/widgets/developer_options_sheet.dart';
import 'package:color_twist/features/store/data/music_catalog.dart';
import 'package:color_twist/features/store/models/store_category.dart';
import 'package:color_twist/features/store/presentation/cubit/store_cubit.dart';
import 'package:color_twist/features/store/presentation/cubit/store_state.dart';
import 'package:color_twist/features/store/presentation/widgets/store_category_tabs.dart';
import 'package:color_twist/features/store/presentation/widgets/store_item_tile.dart';
import 'package:color_twist/features/store/presentation/widgets/store_preview.dart';
import 'package:color_twist/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key, this.theme});

  final GameplayTheme? theme;

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  static const _gold = Color(0xFFFFD700);
  final _audioService = AudioService();
  GameplayTheme _theme = GameplayTheme.dark;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    if (widget.theme != null) {
      setState(() => _theme = widget.theme!);
      return;
    }
    final theme = await AppServices.instance.storeService.loadTheme();
    if (mounted) setState(() => _theme = theme);
  }

  Future<void> _previewMusic(String musicId) async {
    await _audioService.initialize();
    _audioService.playBackgroundMusic(musicTrackPath(musicId));
  }

  GameplayTheme _activeTheme(StoreState state) {
    if (state.selectedCategory == StoreCategory.theme &&
        state.previewItemId != null) {
      return GameplayTheme.byId(state.previewItemId!);
    }
    return _theme;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoreCubit(
        storeService: AppServices.instance.storeService,
      ),
      child: BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final activeTheme = _activeTheme(state);

          return Theme(
            data: AppTheme.forGameplayTheme(activeTheme),
            child: Scaffold(
              backgroundColor: activeTheme.scaffoldColor,
              appBar: AppBar(
                title: const Text('Store'),
                backgroundColor: activeTheme.scaffoldColor,
                actions: [
                  if (DeveloperOptions.isAvailable)
                    IconButton(
                      tooltip: 'Developer options',
                      icon: const Icon(Icons.developer_mode),
                      onPressed: () async {
                        await DeveloperOptionsSheet.show(context);
                        if (context.mounted) {
                          await context.read<StoreCubit>().loadCategory(
                                context.read<StoreCubit>().state.selectedCategory,
                              );
                          setState(() {});
                        }
                      },
                    ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on, color: _gold),
                        const SizedBox(width: 6),
                        Text(
                          '${state.coinBalance}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: _gold,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (DeveloperOptions.unlockAllStoreItems)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: activeTheme.accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: activeTheme.accentColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.developer_mode, color: activeTheme.accentColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Developer mode: all items free to equip',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: activeTheme.secondaryTextColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  StoreCategoryTabs(
                    selected: state.selectedCategory,
                    onSelected: (category) {
                      context.read<StoreCubit>().loadCategory(category);
                    },
                  ),
                  StorePreview(
                    category: state.selectedCategory,
                    theme: activeTheme,
                    previewItemId: state.previewItemId ?? 'classic',
                    equippedBallSkinId: state.equippedBallSkinId,
                  ),
                  if (state.isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final itemState = state.items[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: StoreItemTile(
                              itemState: itemState,
                              category: state.selectedCategory,
                              coinBalance: state.coinBalance,
                              theme: activeTheme,
                              isPreviewing:
                                  itemState.item.id == state.previewItemId,
                              onPreview: () => context
                                  .read<StoreCubit>()
                                  .previewItem(itemState.item.id),
                              onPurchase: () => context
                                  .read<StoreCubit>()
                                  .purchase(itemState.item.id),
                              onEquip: () async {
                                context
                                    .read<StoreCubit>()
                                    .previewItem(itemState.item.id);
                                await context
                                    .read<StoreCubit>()
                                    .equip(itemState.item.id);
                                if (itemState.item.category == StoreCategory.theme) {
                                  setState(
                                    () => _theme = GameplayTheme.byId(
                                      itemState.item.id,
                                    ),
                                  );
                                }
                                if (itemState.item.category == StoreCategory.music) {
                                  await _previewMusic(itemState.item.id);
                                }
                              },
                              onPreviewMusic:
                                  itemState.item.category == StoreCategory.music
                                      ? () => _previewMusic(itemState.item.id)
                                      : null,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
