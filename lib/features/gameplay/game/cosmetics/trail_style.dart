enum TrailStyle {
  drip,
  spark,
  comet,
}

extension TrailStyleX on TrailStyle {
  static TrailStyle fromId(String id) => switch (id) {
        'spark' => TrailStyle.spark,
        'comet' => TrailStyle.comet,
        _ => TrailStyle.drip,
      };

  String get id => switch (this) {
        TrailStyle.drip => 'drip',
        TrailStyle.spark => 'spark',
        TrailStyle.comet => 'comet',
      };
}
