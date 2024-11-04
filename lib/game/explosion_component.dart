// lib/game/explosion_component.dart
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/game.dart';

class ExplosionComponent extends SpriteAnimationComponent with HasGameRef<FlameGame> {
  final Vector2 fixedResolution; // Add this field

  ExplosionComponent(Vector2 position, {required this.fixedResolution}) 
      : super(position: position, size: Vector2.all(fixedResolution.x * 0.125)); // Adjust size based on fixed resolution

  @override
  Future<void> onLoad() async {
    final image = await gameRef.images.load('explosion.png');
    final spriteSize = Vector2(96, 96); // Size of each frame in the sprite sheet
    final spriteAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 12, // Number of frames in the sprite sheet
        stepTime: 0.1 * (fixedResolution.x / 800), // Scale step time based on fixed resolution
        textureSize: spriteSize,
        loop: false, // Ensure the animation only plays once
      ),
    );

    animation = spriteAnimation;
    anchor = Anchor.center; // Set anchor to center
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animationTicker?.done() ?? false) {
      removeFromParent(); // Remove the explosion component once the animation is complete
    }
  }
}
