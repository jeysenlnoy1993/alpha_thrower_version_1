import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:flame/components.dart';

class BackFire extends SpriteAnimationComponent with HasGameRef<MyGame> {
  BackFire({
    SpriteAnimation? animation,
    Vector2? size,
    Vector2? position,
  }) : super(animation: animation, size: size, position: position);
}
