import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fruit_catcher_oz/pages/game_page.dart';

class Score extends StatefulWidget {
  static const String id = "Score";
  final FruitCatcherGame gameRef;
  final int seconds;

  const Score({
    Key? key,
    required this.gameRef,
    required this.seconds,
  }) : super(key: key);

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  late int timeRemaining;

  late Timer timer;
  @override
  void initState() {
    super.initState();

    timeRemaining = widget.seconds * 1000;

    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        timeRemaining -= 10;
      });

      if (timeRemaining <= 0) {
        timer.cancel();
        widget.gameRef.endGame();
      }
    });
  }

  @override
  void dispose() {
    if (timer.isActive) {
      print("cancelling timer");
      timer.cancel();
    }
    super.dispose();
  }

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
                  "Score: ${widget.gameRef.score}",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.deepOrange,
                  ),
                ),
                // Text(
                //   "Life: ${gameRef.life}",
                //   style: TextStyle(
                //     fontSize: 32,
                //     color: Colors.green,
                //   ),
                // ),
                Text(
                  "${(timeRemaining / 1000).toStringAsFixed(2)} ",
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
