// lib/game/astronaut_rescue_animation_component.dart
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/game.dart';
import 'game_config.dart'; // Add this import

class AstronautRescueAnimationComponent extends SpriteAnimationComponent with HasGameRef<FlameGame> {
  AstronautRescueAnimationComponent(Vector2 position) : super(position: position, size: Vector2.all(50));

  @override
  Future<void> onLoad() async {
    final astronautRescue1 = await gameRef.loadSprite('astronaut_rescue1.png');
    final astronautRescue2 = await gameRef.loadSprite('astronaut_rescue2.png');
    final astronautRescue3 = await gameRef.loadSprite('astronaut_rescue3.png');

    final spriteAnimation = SpriteAnimation.spriteList(
      [astronautRescue1, astronautRescue2, astronautRescue3],
      stepTime: 0.1, // Time per frame
      loop: false, // Ensure the animation only plays once
    );

    animation = spriteAnimation;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animationTicker?.done() ?? false) {
      removeFromParent(); // Remove the animation component once the animation is complete
    }
  }
}
