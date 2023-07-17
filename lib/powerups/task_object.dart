import 'dart:math';

import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../player/player.dart';

class TaskObject extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  Vector2 moveDirection = Vector2.zero();
  double speed = 50;
  String type = '';

  late final JoystickComponent joyStick;
  int acquiredPointsPerStage = 0;

  TaskObject({
    SpriteAnimation? animation,
    Vector2? size,
    Vector2? position,
    required String type,
  }) : super(animation: animation, size: size, position: position);

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      if (type == MyGame.lifeStr) {
        gameRef.player.life++;
        gameRef.lifeComponent.text = "X${gameRef.player.life}";
      }

      gameRef.remove(this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(-1, 0) * speed * dt;
    if (x <= 0) gameRef.remove(this);
  }
}
