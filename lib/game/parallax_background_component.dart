// lib/game/parallax_background_component.dart
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'game_config.dart'; // Add this import

class ParallaxBackgroundComponent extends PositionComponent with HasGameRef<FlameGame> {
  late SpriteComponent background1;
  late SpriteComponent background2;
  double speed = 100; // Initial speed of the background movement

  @override
  Future<void> onLoad() async {
    final gameSize = Vector2(GameConfig.fixedWidth, GameConfig.fixedHeight); // Use fixed resolution size

    // Load and scale the background sprites to fully cover the screen dynamically
    background1 = SpriteComponent()
      ..sprite = await gameRef.loadSprite('background.png')
      ..size = gameSize // Set size to match the fixed resolution dimensions
      ..position = Vector2(0, 0); // Position at the top-left

    background2 = SpriteComponent()
      ..sprite = await gameRef.loadSprite('background.png')
      ..size = gameSize // Set size to match the fixed resolution dimensions
      ..position = Vector2(gameSize.x, 0); // Position next to the first background horizontally

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
    if (background1.position.x <= -background1.size.x) {
      background1.position.x = background2.position.x + background2.size.x;
    }
    if (background2.position.x <= -background2.size.x) {
      background2.position.x = background1.position.x + background1.size.x;
    }
  }

  // Method to update the speed based on the score
  void updateSpeed(int score) {
    speed = 100 + score * 10; // Increase speed by a factor of the score
  }
}