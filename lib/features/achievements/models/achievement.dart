import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.coinReward,
  });

  final String id;
  final String title;
  final String description;
  final int coinReward;

  @override
  List<Object?> get props => [id, title, description, coinReward];
}
