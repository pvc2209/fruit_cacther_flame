import 'package:flutter/material.dart';
import 'package:fruit_catcher_oz/pages/game_page.dart';

class GameOver extends StatelessWidget {
  static const String id = "GameOver";
  const GameOver({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

  final FruitCatcherGame gameRef;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "GAME OVER",
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              iconSize: 80,
            )
          ],
        ),
      ),
    );
  }
}
