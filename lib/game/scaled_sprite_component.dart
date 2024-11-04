import 'package:flame/components.dart';

class ScaledSpriteComponent extends SpriteComponent {
  final Vector2 fixedResolution;

  ScaledSpriteComponent({
    required this.fixedResolution,
    required Vector2 size,
    required Sprite sprite,
    Anchor anchor = Anchor.topLeft,
  }) : super(
          size: size * (fixedResolution.y / 1080), // Scale size based on fixed resolution
          sprite: sprite,
          anchor: anchor,
        );
}
