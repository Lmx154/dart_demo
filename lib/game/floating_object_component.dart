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

  FloatingObjectComponent({
    required this.speed,
    required this.rotationSpeed,
    required double size,
    required this.fixedResolution,
  }) : super(
          size: Vector2.zero(), // Initialize size to zero
          anchor: Anchor.center, // Set component anchor to center
        ) {
    // Compute the random size multiplier
    final randomSizeMultiplier = 1.25 + random.nextDouble() * 1.75;
    // Set the size in the constructor body
    this.size = Vector2(size, size) * randomSizeMultiplier;
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

    // Add a circular hitbox centered on the component
    add(
      CircleHitbox()
        ..radius = size.x * 0.4 // Set radius based on component size
        ..position = Vector2.zero() // Position at the component's origin (center)
        ..collisionType = CollisionType.passive
        //..debugMode = true,
    );
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
