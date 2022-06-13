import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      title: "Flowers Catcher",
    ),
  );
}
