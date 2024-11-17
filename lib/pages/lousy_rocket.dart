// lib/pages/lousy_rocket.dart
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/lousy_rocket_game.dart';

class RocketGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lousy Rocket Game'),
      ),
      body: GameWidget(
        game: LousyRocketGame(),
      ),
    );
  }
}
