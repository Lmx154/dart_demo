// lib/game/floating_object_component.dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'dart:math';

class FloatingObjectComponent extends SpriteAnimationComponent with HasGameRef<FlameGame>, CollisionCallbacks {
  final double speed;
  final double rotationSpeed;
  final Random random = Random();

  FloatingObjectComponent({required this.speed, required this.rotationSpeed, required double size}) : super(size: Vector2(size, size));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    animation = await loadAnimation();
    position = Vector2(gameRef.size.x, random.nextDouble() * gameRef.size.y);

    // Add a hitbox for collision detection
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  Future<SpriteAnimation> loadAnimation() async {
    final image = await gameRef.images.load('asteroid.png');
    final spriteSize = Vector2(64, 64);
    return SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1.0,
        textureSize: spriteSize,
      ),
    );
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
