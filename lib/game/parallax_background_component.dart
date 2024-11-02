// lib/game/parallax_background_component.dart
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class ParallaxBackgroundComponent extends PositionComponent with HasGameRef<FlameGame> {
  late SpriteComponent background1;
  late SpriteComponent background2;
  double speed = 100; // Initial speed of the background movement

  @override
  Future<void> onLoad() async {
    // Load the background sprites
    background1 = SpriteComponent()
      ..sprite = await gameRef.loadSprite('background.png')
      ..size = gameRef.size
      ..position = Vector2(0, 0);

    background2 = SpriteComponent()
      ..sprite = await gameRef.loadSprite('background.png')
      ..size = gameRef.size
      ..position = Vector2(gameRef.size.x, 0);

    // Add the background sprites to the component
    add(background1);
    add(background2);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move the backgrounds to the left
    background1.position.x -= speed * dt;
    background2.position.x -= speed * dt;

    // Reset the position of the backgrounds when they go off-screen
    if (background1.position.x <= -gameRef.size.x) {
      background1.position.x = background2.position.x + gameRef.size.x;
    }
    if (background2.position.x <= -gameRef.size.x) {
      background2.position.x = background1.position.x + gameRef.size.x;
    }
  }

  // Method to update the speed based on the score
  void updateSpeed(int score) {
    speed = 100 + score * 10; // Increase speed by a factor of the score
  }
}
