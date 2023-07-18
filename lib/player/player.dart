import 'dart:async';
import 'dart:ui';

import 'package:alpha_thrower_version_1/enemy/enemy.dart';
import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:alpha_thrower_version_1/powerups/task_object.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  Vector2 moveDirection = Vector2.zero();
  double speed = 180;
  int life = 3;
  int collectedPoints = 0;

  late final JoystickComponent joyStick;

  Player({
    SpriteAnimation? animation,
    Vector2? size,
    Vector2? position,
  }) : super(animation: animation, size: size, position: position);

  @override
  void update(double dt) {
    super.update(dt);

    JoystickDirection direction = joyStick.direction;
    double playerWidth = size.x;
    double playerHeight = size.y;
    double gameWidth = gameRef.size.x;
    double gameHeight = gameRef.size.y;

    switch (direction) {
      case JoystickDirection.up:
        y -= speed * dt;
        break;
      case JoystickDirection.upRight:
        x += speed * dt;
        y -= speed * dt;
        break;
      case JoystickDirection.right:
        x += speed * dt;
        break;
      case JoystickDirection.downRight:
        x += speed * dt;
        y += speed * dt;
        break;
      case JoystickDirection.down:
        y += speed * dt;
        break;
      case JoystickDirection.downLeft:
        x -= speed * dt;
        y += speed * dt;
        break;
      case JoystickDirection.left:
        x -= speed * dt;
        break;
      case JoystickDirection.upLeft:
        x -= speed * dt;
        y -= speed * dt;
        break;
      case JoystickDirection.idle:
        // Player is not moving
        break;
    }

    // Clamp the player's position to screen boundaries
    double maxX = gameWidth - playerWidth;
    double maxY = gameHeight - playerHeight;

    x = x.clamp(0, maxX);
    y = y.clamp(0, maxY);
  }

  addJoystickComponent(JoystickComponent newJoyStick) {
    joyStick = newJoyStick;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemy) {
      if (other.shouldRemove) return;
      if (other.hitChecking) return;
      other.hitToPlayer(this);
    }

    if (other is TaskObject) {
      if (other.type == MyGame.lifeStr) {
        life++;
        gameRef.updatePlayerLifeComponent();
      }

      if (other.type == MyGame.taskItemStr) {
        collectedPoints++;
        gameRef.setTaskItemLabel();
      }
      gameRef.remove(other);

      if (other.type == MyGame.taskItemStr) {
        Future.delayed(const Duration(milliseconds: 200), () {
          gameRef.checkLevel();
        });
      }
    }
  }
}
