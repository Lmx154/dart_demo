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
  AstronautComponent({required double speed, required double rotationSpeed, required double size, required Vector2 fixedResolution})
      : super(speed: speed, rotationSpeed: rotationSpeed, size: size, fixedResolution: fixedResolution); // Remove anchor from constructor

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
    position = Vector2(fixedResolution.x, random.nextDouble() * fixedResolution.y); // Randomize the initial position
    anchor = Anchor.center; // Set anchor to center

    // Add a hitbox for collision detection
    add(RectangleHitbox()
      ..position = Vector2.zero() // Position at the component's origin (center)
      ..collisionType = CollisionType.passive
      ..debugMode = true); // Enable debug mode
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is RocketComponent) {
      final game = gameRef as LousyRocketGame;
      game.incrementScore();
      final rescueAnimation = AstronautRescueAnimationComponent(position, fixedResolution: fixedResolution);
      parent?.add(rescueAnimation); // Add rescue animation to the same parent
      removeFromParent(); // Remove the astronaut from the game
      print('Astronaut rescued! Score: ${game.score}');
    }
  }
}
