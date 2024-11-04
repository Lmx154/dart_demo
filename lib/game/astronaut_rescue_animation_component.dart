// lib/game/astronaut_rescue_animation_component.dart
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/game.dart';

class AstronautRescueAnimationComponent extends SpriteAnimationComponent with HasGameRef<FlameGame> {
  final Vector2 fixedResolution; // Add this field

  AstronautRescueAnimationComponent(Vector2 position, {required this.fixedResolution}) 
      : super(position: position, size: Vector2.all(fixedResolution.x * 0.0625), anchor: Anchor.center); // Adjust size based on fixed resolution and set anchor to center

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
    anchor = Anchor.center; // Set anchor to center
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animationTicker?.done() ?? false) {
      removeFromParent(); // Remove the animation component once the animation is complete
    }
  }
}