import 'dart:async';

import 'package:flutter/material.dart';

import '../pages/game_page.dart';

import '../spref/spref.dart';

class Score extends StatefulWidget {
  static const String id = "Score";
  final FruitCatcherGame gameRef;

  const Score({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  int? timeRemaining;

  late Timer timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      int? seconds = await SPref.instance.getInt("seconds");

      if (seconds == null) {
        SPref.instance.setInt("seconds", 10);
        seconds = 10;
      }

      timeRemaining = seconds * 1000;

      timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          timeRemaining = timeRemaining! - 10;
        });

        if (timeRemaining! <= 0) {
          timer.cancel();
          widget.gameRef.endGame();
        }
      });
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
                  timeRemaining == null
                      ? "0.00"
                      : "${(timeRemaining! / 1000).toStringAsFixed(2)} ",
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
