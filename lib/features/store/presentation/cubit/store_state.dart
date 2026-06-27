import 'package:color_twist/features/store/models/store_category.dart';
import 'package:color_twist/features/store/services/store_service.dart';
import 'package:equatable/equatable.dart';

class StoreState extends Equatable {
  const StoreState({
    this.selectedCategory = StoreCategory.ballSkin,
    this.items = const [],
    this.coinBalance = 0,
    this.isLoading = false,
    this.errorMessage,
    this.previewItemId,
    this.equippedBallSkinId = 'classic',
  });

  final StoreCategory selectedCategory;
  final List<StoreItemState> items;
  final int coinBalance;
  final bool isLoading;
  final String? errorMessage;
  final String? previewItemId;
  final String equippedBallSkinId;

  StoreState copyWith({
    StoreCategory? selectedCategory,
    List<StoreItemState>? items,
    int? coinBalance,
    bool? isLoading,
    String? errorMessage,
    String? previewItemId,
    String? equippedBallSkinId,
    bool clearError = false,
  }) {
    return StoreState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      items: items ?? this.items,
      coinBalance: coinBalance ?? this.coinBalance,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      previewItemId: previewItemId ?? this.previewItemId,
      equippedBallSkinId: equippedBallSkinId ?? this.equippedBallSkinId,
    );
  }

  @override
  List<Object?> get props => [
        selectedCategory,
        items,
        coinBalance,
        isLoading,
        errorMessage,
        previewItemId,
        equippedBallSkinId,
      ];
}
