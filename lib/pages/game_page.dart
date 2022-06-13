import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../widgets/game_over.dart';
import '../widgets/score_and_life_widget.dart';

import '../basket.dart';
import '../fruit.dart';
import '../widgets/home_button.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: FruitCatcherGame(),
        overlayBuilderMap: {
          HomeButton.id: (BuildContext context, FruitCatcherGame gameRef) {
            return HomeButton();
          },
          ScoreAndLife.id: (BuildContext context, FruitCatcherGame gameRef) {
            return ScoreAndLife(
              gameRef: gameRef,
            );
          },
          GameOver.id: (BuildContext context, FruitCatcherGame gameRef) {
            return GameOver(
              gameRef: FruitCatcherGame(),
            );
          },
        },
        // Không gọi overlays.add() ở bên trong onload() của game (gọi ở đấy sẽ ko working),
        // mà phải dùng initialActiveOverlays
        initialActiveOverlays: const [HomeButton.id, ScoreAndLife.id],

        backgroundBuilder: (context) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class FruitCatcherGame extends FlameGame
    with HasCollisionDetection, TapDetector, HasDraggables {
  final Basket basket = Basket();
  final List<Fruit> fruits = [];

  late Fruit lastFruit; // fruit have lowest y

  bool gameOver = false;

  int numberOfFruits = 9;
  int score = 0;
  int life = 10;
  bool canSpeedUp = true;

  List<Vector2> randomFruitPositions = [];

  @override
  Future<void>? onLoad() async {
    basket
      ..sprite = await loadSprite("basket.png")
      ..size = Vector2(100, 100)
      ..x = size.x / 2 - 50
      ..y = size.y - 100 - 100
      // ..debugMode = true
      ..anchor = Anchor.topLeft;

    // Random vi tri fruits
    randomFruitPositions
        .add(Vector2(Random().nextInt(size.x.toInt() - 80).toDouble(), -100));

    for (int i = 1; i < numberOfFruits; i++) {
      Vector2 position = Vector2(
        Random().nextInt(size.x.toInt() - 80).toDouble(),
        randomFruitPositions[i - 1].y - 100,
      );

      randomFruitPositions.add(position);
    }

    for (int i = 0; i < randomFruitPositions.length; ++i) {
      fruits.add(
        Fruit()
          ..sprite = await loadSprite("fruit$i.png")
          ..size = Vector2(80, 80)
          ..x = randomFruitPositions[i].x
          ..y = randomFruitPositions[i].y
          // ..debugMode = true
          ..anchor = Anchor.topLeft,
      );
    }

    for (final fruit in fruits) {
      add(fruit);
    }

    lastFruit = fruits.last;

    add(basket);

    return super.onLoad();
  }

  void endGame() {
    gameOver = true;
    overlays.add(GameOver.id);
  }

  @override
  void update(double dt) {
    if (!gameOver) {
      super.update(dt);

      // Update the fruit's position
      for (int i = 0; i < fruits.length; ++i) {
        if (fruits[i].visible == true && fruits[i].y > size.y) {
          life--;
          overlays.remove(ScoreAndLife.id);
          overlays.add(ScoreAndLife.id);

          if (life <= 0) {
            gameOver = true;
            overlays.add(GameOver.id);
          }
        }

        if (fruits[i].y > size.y) {
          fruits[i].x = Random().nextInt(size.x.toInt() - 80).toDouble();
          fruits[i].y = lastFruit.y - 100;

          lastFruit = fruits[i];

          fruits[i].visible = true;
        } else {
          fruits[i].position += fruits[i].velocity * dt;
        }
      }

      // update fruit y speed
      if (score > 0 && score % 10 == 0) {
        if (canSpeedUp) {
          life++;
          for (final fruit in fruits) {
            if (fruit.velocity.y <= 220) {
              fruit.velocity.y += 10;
            } else {
              fruit.velocity.y += 5;
            }
          }

          canSpeedUp = false;
        }
      } else {
        canSpeedUp = true;
      }
    }
  }
}
