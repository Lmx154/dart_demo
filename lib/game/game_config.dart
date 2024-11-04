import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'dart:math';

class GameConfig {
  static const double fixedWidth = 1080;
  static const double fixedHeight = 1920;

  /// Returns the size of the game screen scaled to the fixed resolution.
  /// 
  /// [screenSize] - The actual size of the screen.
  static Vector2 getFixedResolutionSize(Vector2 screenSize) {
    double scale = screenSize.x / fixedWidth;
    return Vector2(fixedWidth * scale, fixedHeight * scale);
  }

  /// Returns the position to center a component on the screen.
  /// 
  /// [screenSize] - The actual size of the screen.
  /// [componentSize] - The size of the component to be centered.
  static Vector2 getCenteredPosition(Vector2 screenSize, Vector2 componentSize) {
    return Vector2(
      (screenSize.x - componentSize.x) / 2,
      (screenSize.y - componentSize.y) / 2,
    );
  }

  /// Returns the position to place a component at the bottom center of the screen.
  /// 
  /// [screenSize] - The actual size of the screen.
  /// [componentSize] - The size of the component to be positioned.
  static Vector2 getBottomCenteredPosition(Vector2 screenSize, Vector2 componentSize) {
    return Vector2(
      (screenSize.x - componentSize.x) / 2,
      screenSize.y - componentSize.y - 50,
    );
  }

  /// Returns a random position within the screen bounds for a component.
  /// 
  /// [screenSize] - The actual size of the screen.
  /// [componentSize] - The size of the component to be positioned.
  static Vector2 getRandomPosition(Vector2 screenSize, Vector2 componentSize) {
    final random = Random();
    return Vector2(
      screenSize.x,
      random.nextDouble() * (screenSize.y - componentSize.y),
    );
  }

  /// Returns the speed scaled by a given factor.
  /// 
  /// [baseSpeed] - The base speed value.
  /// [scale] - The scaling factor.
  static double getScaledSpeed(double baseSpeed, double scale) {
    return baseSpeed * scale;
  }

  /// Returns the size scaled by a given factor.
  /// 
  /// [baseSize] - The base size value.
  /// [scale] - The scaling factor.
  static double getScaledSize(double baseSize, double scale) {
    return baseSize * scale;
  }

  /// Creates and configures the camera component.
  static CameraComponent createCameraComponent(World world) {
    final cameraComponent = CameraComponent.withFixedResolution(
      width: fixedWidth,
      height: fixedHeight,
      world: world,
    );
    cameraComponent.viewfinder.zoom = 1.0;
    cameraComponent.viewport.anchor = Anchor.center; // Center the viewport
    cameraComponent.viewfinder.position = Vector2(fixedWidth / 2, fixedHeight / 2); // Center the camera
    return cameraComponent;
  }
}
