import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:fruit_catcher_oz/widgets/game_over.dart';
import 'package:fruit_catcher_oz/widgets/score_and_life_widget.dart';

import '../basket.dart';
import '../fruit.dart';
import '../widgets/home_button.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    Key? key,
    required this.seconds,
  }) : super(key: key);

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: FruitCatcherGame(),
        overlayBuilderMap: {
          HomeButton.id: (BuildContext context, FruitCatcherGame gameRef) {
            return HomeButton();
          },
          Score.id: (BuildContext context, FruitCatcherGame gameRef) {
            return Score(
              gameRef: gameRef,
              seconds: seconds,
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
        initialActiveOverlays: const [HomeButton.id, Score.id],

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
  // final SpriteComponent background = SpriteComponent();
  final Basket basket = Basket();
  final List<Fruit> fruits = [];

  bool gameOver = false;

  int numberOfFruits = 9;
  int score = 0;
  // int life = 10;
  bool canSpeedUp = true;

  List<Vector2> randomFruitPositions = [];

  @override
  Future<void>? onLoad() async {
    // background
    //   ..sprite = await loadSprite("bg.jpg")
    //   ..size = size;

    // add(background);

    basket
      ..sprite = await loadSprite("basket.png")
      ..size = Vector2(100, 100)
      ..x = size.x / 2 - 50
      ..y = size.y - 100 - 100
      // ..debugMode = true
      ..anchor = Anchor.topLeft;

    for (int i = 0; i < numberOfFruits; i++) {
      Vector2 position = Vector2(
        Random().nextInt(size.x.toInt() - 80).toDouble(),
        -(size.y / numberOfFruits * i),
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

    add(basket);

    // overlays.add(Score.id);
    // overlays.add(HomeButton.id);

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
          // life--;
          overlays.remove(Score.id);
          overlays.add(Score.id);

          // if (life <= 0) {
          //   gameOver = true;
          //   overlays.add(GameOver.id);
          // }
        }

        if (fruits[i].y > size.y) {
          fruits[i].x = Random().nextInt(size.x.toInt() - 80).toDouble();
          fruits[i].y = -80;

          fruits[i].visible = true;
        } else {
          fruits[i].position += fruits[i].velocity * dt;
        }
      }

      // update fruit y speed
      if (score > 0 && score % 10 == 0) {
        if (canSpeedUp) {
          // life++;
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
