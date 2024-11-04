import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'floating_object_component.dart';
import 'astronaut_component.dart'; // Add this import
import 'explosion_component.dart'; // Add this import
import 'lousy_rocket_game.dart'; // Add this import
import 'dart:async'; // Add this import

class RocketComponent extends SpriteComponent with HasGameRef<FlameGame>, CollisionCallbacks {
  final double gravity;
  final double jumpStrength;
  final Vector2 fixedResolution; // Add this field
  double velocity = 0;
  int collisionCount = 0; // Collision counter

  RocketComponent({required this.gravity, required this.jumpStrength, required this.fixedResolution})
      : super(size: Vector2(60, 60) * (fixedResolution.y / 1080)) { // Increase size by 20%
    anchor = Anchor.center; // Set anchor to center
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('rocket.png');
    position = Vector2(fixedResolution.x / 2, fixedResolution.y / 2); // Using fixedResolution to position the rocket

    // Add a circular hitbox centered on the component
    final hitbox = CircleHitbox()
      ..radius = size.x * 0.2 // Reduce radius to 20% of the component size
      ..position = Vector2.zero() // Center the hitbox
      ..collisionType = CollisionType.active;
      //..debugMode = true;

    add(hitbox);
  }

  void applyGravity(double dt) {
    velocity += gravity * dt; // Apply gravity based on delta time
  }

  void updatePosition(double dt) {
    position.y += velocity * dt; // Update position based on delta time
  }

  void jump() {
    velocity = jumpStrength; // Apply jump strength directly
  }

  void checkBoundaries() {
    if (position.y > fixedResolution.y - size.y / 2) {
      position.y = fixedResolution.y - size.y / 2;
      velocity = 0;
    }
    if (position.y < size.y / 2) {
      position.y = size.y / 2;
      velocity = 0;
    }
  }

  void reset() {
    position = Vector2(fixedResolution.x / 2, fixedResolution.y / 2);
    velocity = 0;
    collisionCount = 0; // Reset collision count
  }

  @override
  void update(double dt) {
    super.update(dt);
    applyGravity(dt);
    updatePosition(dt);
    checkBoundaries(); // Use fixed resolution size
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
      final explosion = ExplosionComponent(position, fixedResolution: fixedResolution);
      parent?.add(explosion); // Add explosion to the same parent
      removeFromParent();
      game.stopGame();
    }
  }
}
