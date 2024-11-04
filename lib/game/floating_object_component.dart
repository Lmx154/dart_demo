// lib/game/floating_object_component.dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'dart:math';

class FloatingObjectComponent extends SpriteAnimationComponent with HasGameRef<FlameGame>, CollisionCallbacks {
  final double speed;
  final double rotationSpeed;
  final Random random = Random();
  final Vector2 fixedResolution;

  FloatingObjectComponent({required this.speed, required this.rotationSpeed, required double size, required this.fixedResolution})
      : super(size: Vector2(size, size)) {
    this.size *= (0.5 + random.nextDouble()); // Randomize size between 50% and 150%
    anchor = Anchor.center; // Set anchor to center
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final image = await gameRef.images.load('asteroid.png');
    final spriteSize = Vector2(64, 64); // Size of each frame in the sprite sheet
    final spriteAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 1, // Number of frames in the sprite sheet
        stepTime: 1.0, // Time per frame
        textureSize: spriteSize,
      ),
    );

    animation = spriteAnimation;
    position = Vector2(fixedResolution.x, random.nextDouble() * fixedResolution.y); // Randomize the initial position

    // Add a hitbox for collision detection, slightly smaller than the object size
    add(RectangleHitbox.relative(
      Vector2(0.8, 0.8), // 80% of the object's size
      parentSize: size,
    )..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt * (fixedResolution.x / 800); // Scale speed based on fixed resolution

    // Spin the asteroid in place
    angle += rotationSpeed * dt;

    // Remove the object if it goes off-screen
    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}
