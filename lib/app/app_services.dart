import 'package:color_twist/core/retention/retention_engine.dart';
import 'package:color_twist/core/services/score_service.dart';

class AppServices {
  AppServices._({
    required this.scoreService,
    required this.retentionEngine,
  });

  final ScoreService scoreService;
  final RetentionEngine retentionEngine;

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
    final scoreService = ScoreService();
    await scoreService.initialize();

    final retentionEngine = RetentionEngine(scoreService: scoreService);
    await retentionEngine.initialize();

    _instance = AppServices._(
      scoreService: scoreService,
      retentionEngine: retentionEngine,
    );
    return _instance!;
  }
}
