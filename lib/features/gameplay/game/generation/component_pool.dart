import 'package:flame/components.dart';

class ObstacleComponentPool<T extends PositionComponent> {
  ObstacleComponentPool(this._create, {this.initialSize = 0});

  final T Function() _create;
  final int initialSize;
  final List<T> _available = [];

  T acquire() {
    if (_available.isEmpty) {
      return _create();
    }
    return _available.removeLast();
  }

  void release(T component) {
    if (_available.contains(component)) return;
    _available.add(component);
  }

  int get availableCount => _available.length;
}
