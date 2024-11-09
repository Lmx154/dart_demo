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

class LousyRocketGame extends FlameGame
    with TapDetector, HasCollisionDetection {
  late RocketComponent rocket;
  late ParallaxBackgroundComponent background;
  final Random random = Random();
  double timeSinceLastSpawn = 0;
  double timeSinceLastAstronautSpawn = 0; // Timer for astronaut spawns
  double spawnInterval = 2; // Initial interval in seconds between spawns
  double astronautSpawnInterval =
      5; // Initial interval in seconds between astronaut spawns
  late TextComponent scoreMessage; // Text component for score message
  bool isGameOver = false; // Flag to check if the game is over
  int score = 0; // Score counter

  // Parameters for scaling
  final double gravity = 950;
  final double jumpStrength = -350;
  final double objectSpeed = 100;
  final double objectSize = 50;
  final double speedIncrement = 10; // Speed increment based on score

  late World world; // World component
  late CameraComponent camera; // Camera component

  // Define the fixed resolution
  final Vector2 fixedResolution = Vector2(800, 600);

  LousyRocketGame() {
    world = World();
    camera = CameraComponent.withFixedResolution(
      world: world,
      width: fixedResolution.x,
      height: fixedResolution.y,
    );
    camera.viewfinder.position =
        fixedResolution / 2; // Center the camera on the fixed resolution
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(world);
    add(camera);

    // Adjust the camera viewport based on device aspect ratio
    final deviceAspectRatio = size.x / size.y;
    final fixedAspectRatio = fixedResolution.x / fixedResolution.y;

    if (deviceAspectRatio > fixedAspectRatio) {
      camera.viewfinder.scale = Vector2(
        size.x / fixedResolution.x,
        size.x / fixedResolution.x,
      );
    } else {
      camera.viewfinder.scale = Vector2(
        size.y / fixedResolution.y,
        size.y / fixedResolution.y,
      );
    }

    background = ParallaxBackgroundComponent(fixedResolution: fixedResolution);
    world.add(background);

    rocket = RocketComponent(
      gravity: gravity,
      jumpStrength: jumpStrength,
      fixedResolution: fixedResolution,
    );
    world.add(rocket);

    // Initialize and add the score message text component
    scoreMessage = TextComponent(
      text: 'Score: $score',
      position: Vector2(fixedResolution.x / 2,
          50), // Centered horizontally in the fixed resolution
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
    return objectSpeed + score * speedIncrement;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) {
      overlays.add('GameOver');
      return; // Stop updating if the game is over
    }

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
    final speed = getCurrentSpeed();
    final rotationSpeed =
        (random.nextDouble() - 0.5) * 2; // Random rotation speed
    final floatingObject = FloatingObjectComponent(
      speed: speed,
      rotationSpeed: rotationSpeed,
      size: objectSize *
          (fixedResolution.y / 1080), // Scale size based on fixed resolution
      fixedResolution: fixedResolution,
    );
    world.add(floatingObject);
  }

  void spawnAstronaut() {
    final speed = getCurrentSpeed();
    final rotationSpeed =
        (random.nextDouble() - 0.5) * 2; // Random rotation speed
    final astronaut = AstronautComponent(
      speed: speed,
      rotationSpeed: rotationSpeed,
      size: objectSize *
          0.6 *
          (fixedResolution.y / 1080), // Scale size based on fixed resolution
      fixedResolution: fixedResolution,
    );
    world.add(astronaut);
  }

  void updateSpawnRate(int score) {
    // Decrease the spawn interval as the score increases
    spawnInterval =
        max(0.5, 2 - score * 0.05); // Minimum interval of 0.5 seconds
    astronautSpawnInterval = max(
        1.0, 5 - score * 0.1); // Adjust astronaut spawn interval based on score
  }

  // Method to update the score
  void incrementScore() {
    score++;
    scoreMessage.text = 'Score: $score';
  }

  // Method to stop the game
  void stopGame() {
    isGameOver = true;
  }

  void resetGame() {
    // Reset game state variables
    isGameOver = false;
    score = 0;
    timeSinceLastSpawn = 0;
    timeSinceLastAstronautSpawn = 0;

    // Clear all components from the world
    world.children.clear();

    // Re-add essential components
    world.add(background);

    // Recreate the rocket component to ensure a fresh state
    rocket = RocketComponent(
      gravity: gravity,
      jumpStrength: jumpStrength,
      fixedResolution: fixedResolution,
    );
    world.add(rocket);

    world.add(scoreMessage);

    // Reset score message
    scoreMessage.text = 'Score: $score';

    // Remove the GameOver overlay
    overlays.remove('GameOver');
  }
}
