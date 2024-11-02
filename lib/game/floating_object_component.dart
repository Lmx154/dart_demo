// lib/game/floating_object_component.dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'dart:math';

class FloatingObjectComponent extends SpriteComponent with HasGameRef<FlameGame>, CollisionCallbacks {
  final double speed;
  final double rotationSpeed;
  final Random random = Random();

  FloatingObjectComponent({required this.speed, required this.rotationSpeed}) : super() {
    // Initialize the size within the constructor body
    size = Vector2(50 + random.nextDouble() * 50, 50 + random.nextDouble() * 50);
  }

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('asteroid.png'); // Load the floating object image
    position = Vector2(gameRef.size.x, random.nextDouble() * gameRef.size.y); // Randomize the initial position

    // Add a hitbox for collision detection
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt; // Move the object to the left
    angle += rotationSpeed * dt; // Rotate the object

    // Remove the object if it goes off-screen
    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}
