// lib/game/lousy_rocket_game.dart
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';
import 'rocket_component.dart';
import 'parallax_background_component.dart';
import 'floating_object_component.dart';
import 'dart:math';

class LousyRocketGame extends FlameGame with TapDetector, HasCollisionDetection {
  late RocketComponent rocket;
  late ParallaxBackgroundComponent background;
  final Random random = Random();
  double timeSinceLastSpawn = 0;
  double spawnInterval = 2; // Initial interval in seconds between spawns

  @override
  Future<void> onLoad() async {
    background = ParallaxBackgroundComponent();
    add(background);

    rocket = RocketComponent();
    add(rocket);
  }

  @override
  void update(double dt) {
    super.update(dt);
    rocket.applyGravity();
    rocket.updatePosition();
    rocket.checkBoundaries(size);

    // Example: Update the background speed based on a hypothetical score
    int score = 50; // Replace this with actual score logic
    background.updateSpeed(score);

    // Adjust the spawn rate based on the score
    updateSpawnRate(score);

    // Update the speed of floating objects to match the background speed
    timeSinceLastSpawn += dt;
    if (timeSinceLastSpawn >= spawnInterval) {
      spawnFloatingObject();
      timeSinceLastSpawn = 0;
    }
  }

  @override
  void onTap() {
    rocket.jump();
  }

  void spawnFloatingObject() {
    final speed = background.speed;
    final rotationSpeed = (random.nextDouble() - 0.5) * 2; // Random rotation speed
    final floatingObject = FloatingObjectComponent(speed: speed, rotationSpeed: rotationSpeed);
    add(floatingObject);
  }

  void updateSpawnRate(int score) {
    // Decrease the spawn interval as the score increases
    spawnInterval = max(0.5, 2 - score * 0.05); // Minimum interval of 0.5 seconds
  }
}
