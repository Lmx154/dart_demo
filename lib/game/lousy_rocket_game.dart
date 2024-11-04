import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'rocket_component.dart';
import 'parallax_background_component.dart';
import 'floating_object_component.dart';
import 'astronaut_component.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/experimental.dart';
import 'game_config.dart'; // Add this import

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
  double speedIncrement = 10; // Speed increment based on score

  late World world; // Declare world as a class member

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    world = World();
    add(world);

    // Create and add the camera component using GameConfig
    final cameraComponent = GameConfig.createCameraComponent(world);
    add(cameraComponent);

    // Load and add the background
    background = ParallaxBackgroundComponent();
    world.add(background);

    // Load and add the rocket
    rocket = RocketComponent(gravity: baseGravity, jumpStrength: baseJumpStrength);
    world.add(rocket);

    // Remove the camera follow call
    // cameraComponent.follow(rocket);

    // Initialize and add the collision message text component
    collisionMessage = TextComponent(
      text: '',
      position: GameConfig.getCenteredPosition(Vector2(GameConfig.fixedWidth, 40), Vector2(200, 20)),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      ),
    );
    world.add(collisionMessage);

    // Initialize and add the score message text component
    scoreMessage = TextComponent(
      text: 'Score: $score',
      position: GameConfig.getCenteredPosition(Vector2(GameConfig.fixedWidth, 70), Vector2(200, 20)),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    world.add(scoreMessage);
  }

  double getCurrentSpeed() {
    return baseObjectSpeed + score * speedIncrement;
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
      spawnObject();
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

  void spawnObject() {
    final speed = getCurrentSpeed();
    final rotationSpeed = (random.nextDouble() - 0.5) * 2;
    final shouldSpawnAstronaut = random.nextDouble() < 0.2; // 20% chance

    final object = shouldSpawnAstronaut
        ? AstronautComponent(
            speed: speed,
            rotationSpeed: rotationSpeed,
            size: baseObjectSize * 0.6,
          )
        : FloatingObjectComponent(
            speed: speed,
            rotationSpeed: rotationSpeed,
            size: baseObjectSize,
          );

    world.add(object); // Add to the world
  }

  void spawnAstronaut() {
    final speed = getCurrentSpeed();
    final rotationSpeed = (random.nextDouble() - 0.5) * 2;

    final astronaut = AstronautComponent(
      speed: speed,
      rotationSpeed: rotationSpeed,
      size: baseObjectSize * 0.6,
    );

    world.add(astronaut); // Add to the world
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
