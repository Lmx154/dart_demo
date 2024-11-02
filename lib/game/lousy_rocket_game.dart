// lib/game/lousy_rocket_game.dart
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'rocket_component.dart'; // Updated import
import 'parallax_background_component.dart';

class LousyRocketGame extends FlameGame with TapDetector { // Updated class name
  late RocketComponent rocket; // Updated variable name
  late ParallaxBackgroundComponent background;

  @override
  Future<void> onLoad() async {
    background = ParallaxBackgroundComponent();
    add(background);

    rocket = RocketComponent(); // Updated variable name
    add(rocket);
  }

  @override
  void update(double dt) {
    super.update(dt);
    rocket.applyGravity(); // Updated method call
    rocket.updatePosition(); // Updated method call
    rocket.checkBoundaries(size); // Updated method call

    // Example: Update the background speed based on a hypothetical score
    int score = 50; // Replace this with actual score logic
    background.updateSpeed(score);
  }

  @override
  void onTap() {
    rocket.jump(); // Updated method call
  }
}
