// lib/game/astronaut_component.dart
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/game.dart';
import 'package:flame/collisions.dart'; // Add this import
import 'floating_object_component.dart';
import 'lousy_rocket_game.dart';
import 'rocket_component.dart'; // Add this import

class AstronautComponent extends FloatingObjectComponent {
  AstronautComponent({required double speed, required double rotationSpeed, required double size})
      : super(speed: speed, rotationSpeed: rotationSpeed, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final astronaut1 = await gameRef.loadSprite('astronaut1.png');
    final astronaut2 = await gameRef.loadSprite('astronaut2.png');

    final spriteAnimation = SpriteAnimation.spriteList(
      [astronaut1, astronaut2],
      stepTime: 0.5, // Time per frame
    );

    animation = spriteAnimation;
    position = Vector2(gameRef.size.x, random.nextDouble() * gameRef.size.y); // Randomize the initial position

    // Add a hitbox for collision detection
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is RocketComponent) {
      final game = gameRef as LousyRocketGame;
      game.incrementScore();
      removeFromParent(); // Remove the astronaut from the game
      print('Astronaut rescued! Score: ${game.score}');
    }
  }
}
