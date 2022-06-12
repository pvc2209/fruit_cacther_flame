import 'package:flutter/material.dart';

import '../pages/game_page.dart';

class ScoreAndLife extends StatelessWidget {
  static const String id = "ScoreAndLife";
  final FruitCatcherGame gameRef;

  const ScoreAndLife({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
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
                  "Score: ${gameRef.score}",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.deepOrange,
                  ),
                ),
                Text(
                  "Life: ${gameRef.life}",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
