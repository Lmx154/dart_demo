// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/lousy_rocket_game.dart';
import 'overlays/game_over.dart';

void main() {
  runApp(
    GameWidget<LousyRocketGame>.controlled(
      gameFactory: LousyRocketGame.new,
      overlayBuilderMap: {
        'GameOver': (_, game) => GameOver(game: game),
      },
      initialActiveOverlays: const [],
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lousy Rocket', // Updated title
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GameWidget(game: LousyRocketGame()),
      ),
    );
  }
}
