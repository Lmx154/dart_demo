// lib/game/explosion_component.dart
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/game.dart';

class ExplosionComponent extends SpriteAnimationComponent with HasGameRef<FlameGame> {
  ExplosionComponent(Vector2 position) : super(position: position, size: Vector2.all(100));

  @override
  Future<void> onLoad() async {
    final image = await gameRef.images.load('explosion.png');
    final spriteSize = Vector2(96, 96); // Size of each frame in the sprite sheet
    final spriteAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 12, // Number of frames in the sprite sheet
        stepTime: 0.1, // Time per frame
        textureSize: spriteSize,
        loop: false, // Ensure the animation only plays once
      ),
    );

    animation = spriteAnimation;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animationTicker?.done() ?? false) {
      removeFromParent(); // Remove the explosion component once the animation is complete
    }
  }
}
