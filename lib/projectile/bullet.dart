import 'dart:ui';

import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../enemy/enemy.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final speed = 200;
  bool shouldRemove = false;

  int power = 1;

  Bullet({
    SpriteAnimation? animation,
    Vector2? size,
    Vector2? position,
  }) : super(animation: animation, size: size, position: position);

  @override
  void update(double dt) {
    super.update(dt);
    position.x += speed * dt;
    if (position.x >= gameRef.size.x) gameRef.remove(this);
  }

  @override
  void onRemove() {
    super.onRemove();
    shouldRemove = true;
  }
}
