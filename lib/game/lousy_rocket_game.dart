import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'rocket_component.dart';
import 'parallax_background_component.dart';
import 'floating_object_component.dart';
import 'astronaut_component.dart'; // Add this import
import 'dart:math';
import 'package:flutter/material.dart'; // Add this import for TextStyle

class LousyRocketGame extends FlameGame with TapDetector, HasCollisionDetection {
  late RocketComponent rocket;
  late ParallaxBackgroundComponent background;
  final Random random = Random();
  double timeSinceLastSpawn = 0;
  double timeSinceLastAstronautSpawn = 0; // Timer for astronaut spawns
  double spawnInterval = 2; // Initial interval in seconds between spawns
  double astronautSpawnInterval = 5; // Initial interval in seconds between astronaut spawns
  late TextComponent collisionMessage; // Text component for collision message
  late TextComponent scoreMessage; // Text component for score message
  bool isGameOver = false; // Flag to check if the game is over
  int score = 0; // Score counter

  // Parameters for scaling
  double baseGravity = 0.5;
  double baseJumpStrength = -10;
  double baseObjectSpeed = 100;
  double baseObjectSize = 50;

  @override
  Future<void> onLoad() async {
    background = ParallaxBackgroundComponent();
    add(background);

    rocket = RocketComponent(
      gravity: scaleValue(baseGravity),
      jumpStrength: scaleValue(baseJumpStrength),
    );
    add(rocket);

    // Initialize and add the collision message text component
    collisionMessage = TextComponent(
      text: '',
      position: Vector2(size.x / 2, 20), // Centered horizontally, 20 units from the top
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      ),
    );
    add(collisionMessage);

    // Initialize and add the score message text component
    scoreMessage = TextComponent(
      text: 'Score: $score',
      position: Vector2(size.x / 2, 50), // Centered horizontally, 50 units from the top
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    add(scoreMessage);
  }

  double scaleValue(double baseValue) {
    return baseValue * (size.y / 1080);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return; // Stop updating if the game is over

    rocket.applyGravity();
    rocket.updatePosition();
    rocket.checkBoundaries(size);

    // Example: Update the background speed based on a hypothetical score
    background.updateSpeed(score);

    // Adjust the spawn rate based on the score
    updateSpawnRate(score);

    // Update the speed of floating objects to match the background speed
    timeSinceLastSpawn += dt;
    if (timeSinceLastSpawn >= spawnInterval) {
      spawnFloatingObject();
      timeSinceLastSpawn = 0;
    }

    // Update the astronaut spawn timer
    timeSinceLastAstronautSpawn += dt;
    if (timeSinceLastAstronautSpawn >= astronautSpawnInterval) {
      spawnAstronaut();
      timeSinceLastAstronautSpawn = 0;
    }
  }

  @override
  void onTap() {
    if (!isGameOver) {
      rocket.jump();
    }
  }

  void spawnFloatingObject() {
    final speed = scaleValue(baseObjectSpeed);
    final rotationSpeed = (random.nextDouble() - 0.5) * 2; // Random rotation speed
    final floatingObject = FloatingObjectComponent(
      speed: speed,
      rotationSpeed: rotationSpeed,
      size: scaleValue(baseObjectSize),
    );
    add(floatingObject);
  }

  void spawnAstronaut() {
    final speed = scaleValue(baseObjectSpeed);
    final rotationSpeed = (random.nextDouble() - 0.5) * 2; // Random rotation speed
    final astronaut = AstronautComponent(
      speed: speed,
      rotationSpeed: rotationSpeed,
      size: scaleValue(baseObjectSize * 0.6), // Smaller size for astronauts
    );
    add(astronaut);
  }

  void updateSpawnRate(int score) {
    // Decrease the spawn interval as the score increases
    spawnInterval = max(0.5, 2 - score * 0.05); // Minimum interval of 0.5 seconds
    astronautSpawnInterval = max(1.0, 5 - score * 0.1); // Adjust astronaut spawn interval based on score
  }

  // Method to update the collision message text
  void updateCollisionMessage(String message) {
    collisionMessage.text = message;
  }

  // Method to increment the score
  void incrementScore() {
    score++;
    scoreMessage.text = 'Score: $score';
  }

  // Method to stop the game
  void stopGame() {
    isGameOver = true;
  }
}
