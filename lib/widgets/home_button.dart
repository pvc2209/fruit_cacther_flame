import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  static const String id = "HomeButton";
  const HomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(20),
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}
