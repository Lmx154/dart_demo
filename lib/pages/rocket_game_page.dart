import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/lousy_rocket_game.dart';

class RocketGamePage extends StatelessWidget {
  final LousyRocketGame game = LousyRocketGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lousy Rocket Game'),
      ),
      body: Stack(
        children: [
          GameWidget(game: game),
          // Ensure game.isGameOver is correctly handled
          if (game.isGameOver)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Game Over',
                    style: TextStyle(fontSize: 32, color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      game.resetGame();
                    },
                    child: Text('Restart'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
