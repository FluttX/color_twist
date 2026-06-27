enum ExplosionStyle {
  burst,
  shatter,
  nova,
}

extension ExplosionStyleX on ExplosionStyle {
  static ExplosionStyle fromId(String id) => switch (id) {
        'shatter' => ExplosionStyle.shatter,
        'nova' => ExplosionStyle.nova,
        _ => ExplosionStyle.burst,
      };

  String get id => switch (this) {
        ExplosionStyle.burst => 'burst',
        ExplosionStyle.shatter => 'shatter',
        ExplosionStyle.nova => 'nova',
      };
}
