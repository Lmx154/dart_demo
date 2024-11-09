// lib/game/explosion_component.dart
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/game.dart';

class ExplosionComponent extends SpriteAnimationComponent
    with HasGameRef<FlameGame> {
  final Vector2 fixedResolution;

  ExplosionComponent(Vector2 position, {required this.fixedResolution})
      : super(position: position, size: Vector2.all(fixedResolution.x * 0.125));

  @override
  Future<void> onLoad() async {
    final image = await gameRef.images.load('explosion.png');
    final spriteSize = Vector2(96, 96);
    final spriteAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 12,
        stepTime: 0.1 * (fixedResolution.x / 800),
        textureSize: spriteSize,
        loop: false,
      ),
    );

    animation = spriteAnimation;
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animationTicker?.done() ?? false) {
      removeFromParent();
    }
  }
}
