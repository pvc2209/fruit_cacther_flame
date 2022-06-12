import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:fruit_catcher_oz/fruit.dart';

import 'pages/game_page.dart';
import 'widgets/score_and_life_widget.dart';

class Basket extends SpriteComponent
    with CollisionCallbacks, HasGameRef<FruitCatcherGame>, Draggable {
  @override
  Future<void>? onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (!(y >= other.y + other.height - 10 &&
        (other as Fruit).visible == true)) {
      if (other.x > x) {
        other.x = x + width;
      } else if (other.x < x) {
        other.x = x - other.width;
      }
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (y >= other.y + other.height - 10 && (other as Fruit).visible == true) {
      other.visible = false;

      gameRef.score += 1;

      gameRef.overlays.remove(Score.id);
      gameRef.overlays.add(Score.id);
    }
  }

  Vector2? dragDeltaPosition;
  bool get isDragging => dragDeltaPosition != null;

  @override
  bool onDragStart(DragStartInfo info) {
    dragDeltaPosition = info.eventPosition.game - position;
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    if (isDragging) {
      final localCoords = info.eventPosition.game;
      position = localCoords - dragDeltaPosition!;
    }
    return false;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    dragDeltaPosition = null;
    return false;
  }

  @override
  bool onDragCancel() {
    dragDeltaPosition = null;
    return false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (y < gameRef.size.y - height - 100) {
      y = gameRef.size.y - height - 100;
    }

    if (y + 100 > gameRef.size.y - height) {
      y = gameRef.size.y - height - 100;
    }

    if (x < 0) {
      x = 0;
    }

    if (x + 100 > gameRef.size.x) {
      x = gameRef.size.x - 100;
    }
  }
}
