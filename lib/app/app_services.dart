import 'package:color_twist/core/debug/developer_options.dart';
import 'package:color_twist/core/retention/retention_engine.dart';
import 'package:color_twist/core/services/player_progress_service.dart';
import 'package:color_twist/core/services/score_service.dart';
import 'package:color_twist/features/store/services/store_service.dart';

class AppServices {
  AppServices._({
    required this.scoreService,
    required this.retentionEngine,
    required this.storeService,
  });

  final ScoreService scoreService;
  final RetentionEngine retentionEngine;
  final StoreService storeService;

  static AppServices? _instance;

  static AppServices get instance {
    final services = _instance;
    if (services == null) {
      throw StateError(
        'AppServices not initialized. Call AppServices.init() first.',
      );
    }
    return services;
  }

  static Future<AppServices> init() async {
    await DeveloperOptions.initialize();

    final scoreService = ScoreService();
    await scoreService.initialize();

    final progressService = PlayerProgressService();
    final retentionEngine = RetentionEngine(
      scoreService: scoreService,
      progressService: progressService,
    );
    await retentionEngine.initialize();

    final storeService = StoreService(progressService: progressService);
    await storeService.initialize();

    _instance = AppServices._(
      scoreService: scoreService,
      retentionEngine: retentionEngine,
      storeService: storeService,
    );
    return _instance!;
  }
}
