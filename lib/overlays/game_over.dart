import 'package:flutter/material.dart';
import '../game/lousy_rocket_game.dart';
import '../services/api_service.dart'; // Ensure correct import path

class GameOver extends StatefulWidget {
  final LousyRocketGame game;
  const GameOver({super.key, required this.game});

  @override
  _GameOverState createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  final TextEditingController _nameController = TextEditingController();
  final ApiService _apiService = ApiService(); // Ensure correct instantiation
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 300, // Adjusted height
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
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
                const SizedBox(height: 20),
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
                    onPressed: isLoading ? null : _submitScore,
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Submit Score to Leaderboard',
                            style: TextStyle(fontSize: 16.0),
                          ),
                  ),
                ),
                if (errorMessage != null) ...[
                  SizedBox(height: 10),
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
                SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.game.resetGame();
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

  Future<void> _submitScore() async {
    String playerName = _nameController.text.trim();
    if (playerName.isEmpty) {
      setState(() {
        errorMessage = 'Player name cannot be empty.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _apiService.postRequest('/api/Leaderboard', {'name': playerName, 'score': widget.game.score});
      setState(() {
        isLoading = false;
      });
      // Optionally, show a success message
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to submit score.';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
