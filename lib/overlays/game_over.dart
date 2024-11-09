import 'package:flutter/material.dart';
import '../game/lousy_rocket_game.dart';

class GameOver extends StatefulWidget {
  final LousyRocketGame game;
  const GameOver({super.key, required this.game});

  @override
  _GameOverState createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 300, // Increased height from 200 to 300
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            // Added SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Game Over',
                  style: TextStyle(
                    color: whiteTextColor,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Player Name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      String playerName = _nameController.text;
                      // TODO: Implement score submission logic
                      // Example: widget.game.submitScore(playerName, widget.game.score);
                    },
                    child: Text(
                      'Submit Score to Leaderboard',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.game.resetGame();
                      // game.overlays.remove('GameOver');
                      // Navigator.pop(context); // Navigate back to Home Page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteTextColor,
                    ),
                    child: const Text(
                      'Play Again',
                      style: TextStyle(
                        fontSize: 28.0,
                        color: blackTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
