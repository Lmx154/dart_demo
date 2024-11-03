// lib/game/astronaut_component.dart
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/game.dart';
import 'package:flame/collisions.dart'; // Add this import
import 'floating_object_component.dart';
import 'lousy_rocket_game.dart';
import 'rocket_component.dart'; // Add this import
import 'astronaut_rescue_animation_component.dart'; // Add this import

class AstronautComponent extends FloatingObjectComponent {
  AstronautComponent({required double speed, required double rotationSpeed, required double size})
      : super(speed: speed, rotationSpeed: rotationSpeed, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    animation = await loadAnimation();
    position = Vector2(gameRef.size.x, random.nextDouble() * gameRef.size.y); // Randomize the initial position

    // Add a hitbox for collision detection
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  Future<SpriteAnimation> loadAnimation() async {
    final astronaut1 = await gameRef.loadSprite('astronaut1.png');
    final astronaut2 = await gameRef.loadSprite('astronaut2.png');
    return SpriteAnimation.spriteList(
      [astronaut1, astronaut2],
      stepTime: 0.5,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is RocketComponent) {
      final game = gameRef as LousyRocketGame;
      game.incrementScore();
      final rescueAnimation = AstronautRescueAnimationComponent(position);
      game.add(rescueAnimation);
      removeFromParent(); // Remove the astronaut from the game
      print('Astronaut rescued! Score: ${game.score}');
    }
  }
}
