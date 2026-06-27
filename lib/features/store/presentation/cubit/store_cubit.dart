import 'package:color_twist/features/store/models/store_category.dart';
import 'package:color_twist/features/store/presentation/cubit/store_state.dart';
import 'package:color_twist/features/store/services/store_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreCubit extends Cubit<StoreState> {
  StoreCubit({required StoreService storeService})
      : _storeService = storeService,
        super(const StoreState()) {
    loadCategory(StoreCategory.ballSkin);
  }

  final StoreService _storeService;

  Future<void> loadCategory(StoreCategory category) async {
    emit(state.copyWith(isLoading: true, selectedCategory: category, clearError: true));
    final items = await _storeService.loadCategoryItems(category);
    final balance = _storeService.coinBalance;
    final equippedId = await _storeService.getEquipped(category);
    final appearance = await _storeService.loadAppearance();
    emit(
      state.copyWith(
        items: items,
        coinBalance: balance,
        isLoading: false,
        previewItemId: equippedId,
        equippedBallSkinId: appearance.ballSkinId,
      ),
    );
  }

  void previewItem(String itemId) {
    emit(state.copyWith(previewItemId: itemId));
  }

  Future<bool> purchase(String itemId) async {
    final success = await _storeService.purchase(itemId);
    if (!success) {
      emit(state.copyWith(errorMessage: 'Not enough coins'));
      return false;
    }
    await loadCategory(state.selectedCategory);
    return true;
  }

  Future<bool> equip(String itemId) async {
    final success = await _storeService.equip(itemId);
    if (!success) return false;
    await loadCategory(state.selectedCategory);
    return true;
  }
}
