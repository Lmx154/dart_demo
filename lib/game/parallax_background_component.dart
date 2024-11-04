// lib/game/parallax_background_component.dart
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class ParallaxBackgroundComponent extends PositionComponent with HasGameRef<FlameGame> {
  late SpriteComponent background1;
  late SpriteComponent background2;
  double speed = 100; // Initial speed of the background movement
  final Vector2 fixedResolution; // Add this field

  ParallaxBackgroundComponent({required this.fixedResolution}) : super(); // Remove anchor from constructor

  @override
  Future<void> onLoad() async {
    // Load the background sprites
    background1 = SpriteComponent()
      ..sprite = await gameRef.loadSprite('background.png')
      ..size = fixedResolution
      ..position = Vector2(0, 0);

    background2 = SpriteComponent()
      ..sprite = await gameRef.loadSprite('background.png')
      ..size = fixedResolution
      ..position = Vector2(fixedResolution.x, 0);

    // Add the background sprites to the component
    add(background1);
    add(background2);

    anchor = Anchor.center; // Set anchor to center
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move the backgrounds to the left
    background1.position.x -= speed * dt * (fixedResolution.x / 800); // Scale speed based on fixed resolution
    background2.position.x -= speed * dt * (fixedResolution.x / 800); // Scale speed based on fixed resolution

    // Reset the position of the backgrounds when they go off-screen
    if (background1.position.x <= -fixedResolution.x) {
      background1.position.x = background2.position.x + fixedResolution.x;
    }
    if (background2.position.x <= -fixedResolution.x) {
      background2.position.x = background1.position.x + fixedResolution.x;
    }
  }

  // Method to update the speed based on the score
  void updateSpeed(int score) {
    speed = 100 + score * 10; // Increase speed by a factor of the score
  }
}
