import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Fruit extends SpriteComponent {
  bool visible = true;
  Vector2 velocity = Vector2(0, 120);

  @override
  Future<void>? onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    if (visible) {
      super.render(canvas);
    }
  }
}
