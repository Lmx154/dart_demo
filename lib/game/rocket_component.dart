// lib/game/rocket_component.dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'floating_object_component.dart'; // Add this import
import 'package:flutter/material.dart'; // Add this import for TextStyle

class RocketComponent extends SpriteComponent with HasGameRef<FlameGame>, CollisionCallbacks {
  final double gravity = 0.5;
  final double jumpStrength = -10;
  double velocity = 0;
  int collisionCount = 0; // Collision counter
  late TextComponent collisionMessage; // Text component for collision message

  RocketComponent() : super(size: Vector2(50, 50)) {
    // Initialize the collision message text component
    collisionMessage = TextComponent(
      text: '',
      position: Vector2(0, 0), // Temporary position, will be updated in onLoad
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('rocket.png');
    position = Vector2(gameRef.size.x / 2 - 25, gameRef.size.y / 2 - 25);

    // Add a hitbox for collision detection
    add(RectangleHitbox()..collisionType = CollisionType.active);

    // Update the position of the collision message and add it to the component tree
    collisionMessage.position = Vector2(position.x + size.x / 2, position.y - 20);
    add(collisionMessage);
  }

  void applyGravity() {
    velocity += gravity;
  }

  void updatePosition() {
    position.y += velocity;
    collisionMessage.position = Vector2(position.x + size.x / 2, position.y - 20); // Update message position
  }

  void jump() {
    velocity = jumpStrength;
  }

  void checkBoundaries(Vector2 gameSize) {
    if (position.y > gameSize.y - size.y) {
      position.y = gameSize.y - size.y;
      velocity = 0;
    }
    if (position.y < 0) {
      position.y = 0;
      velocity = 0;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is FloatingObjectComponent) {
      // Handle collision with floating object
      collisionCount++;
      collisionMessage.text = 'Collision detected! Count: $collisionCount';
      print('Collision with floating object! Count: $collisionCount');
    }
  }
}
