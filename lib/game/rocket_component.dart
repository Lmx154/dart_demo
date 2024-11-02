// lib/game/rocket_component.dart
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class RocketComponent extends SpriteComponent with HasGameRef<FlameGame> { // Updated class name
  final double gravity = 0.5;
  final double jumpStrength = -10;
  double velocity = 0;

  RocketComponent() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('rocket.png'); // Updated asset name
    position = Vector2(gameRef.size.x / 2 - 25, gameRef.size.y / 2 - 25);
  }

  void applyGravity() {
    velocity += gravity;
  }

  void updatePosition() {
    position.y += velocity;
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
}
