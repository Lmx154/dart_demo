import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'floating_object_component.dart';
import 'astronaut_component.dart'; // Add this import
import 'explosion_component.dart'; // Add this import
import 'lousy_rocket_game.dart'; // Add this import
import 'game_config.dart'; // Add this import

class RocketComponent extends SpriteComponent with HasGameRef<FlameGame>, CollisionCallbacks {
  final double gravity;
  final double jumpStrength;
  double velocity = 0;
  int collisionCount = 0; // Collision counter

  RocketComponent({required this.gravity, required this.jumpStrength}) : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('rocket.png');
    // Center the rocket in the fixed resolution
    position = GameConfig.getCenteredPosition(gameRef.size, size);

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
    final game = gameRef as LousyRocketGame;

    if (other is FloatingObjectComponent && other is! AstronautComponent) {
      // Handle collision with space debris
      collisionCount++;
      game.updateCollisionMessage('Collision detected! Count: $collisionCount');
      print('Collision with space debris! Count: $collisionCount');

      // Replace rocket with explosion animation and stop the game
      final explosion = ExplosionComponent(position);
      game.add(explosion);
      removeFromParent();
      game.stopGame();
    }
  }
}