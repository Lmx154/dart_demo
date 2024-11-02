import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'floating_object_component.dart';
import 'explosion_component.dart'; // Add this import
import 'lousy_rocket_game.dart'; // Add this import

class RocketComponent extends SpriteComponent with HasGameRef<FlameGame>, CollisionCallbacks {
  final double gravity = 0.5;
  final double jumpStrength = -10;
  double velocity = 0;
  int collisionCount = 0; // Collision counter

  RocketComponent() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('rocket.png');
    position = Vector2(gameRef.size.x / 2 - 25, gameRef.size.y / 2 - 25);

    // Add a hitbox for collision detection
    add(RectangleHitbox()..collisionType = CollisionType.active);
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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is FloatingObjectComponent) {
      // Handle collision with floating object
      collisionCount++;
      final game = gameRef as LousyRocketGame;
      game.updateCollisionMessage('Collision detected! Count: $collisionCount');
      print('Collision with floating object! Count: $collisionCount');

      // Replace rocket with explosion animation and stop the game
      final explosion = ExplosionComponent(position);
      game.add(explosion);
      removeFromParent();
      game.stopGame();
    }
  }
}
