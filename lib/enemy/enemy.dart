import 'dart:math';
import 'dart:ui';

import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:alpha_thrower_version_1/player/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import '../projectile/bullet.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  double speed = 150;
  int scoreWhenKilled = 5;
  bool shouldRemove = false;
  int life = 1;
  bool hitChecking = false;
  int power = 1;

  bool canTakeDamage = true;
  final cooldownDuration = const Duration(seconds: 1);
  Timer? cooldownTimer;

  Random _random = Random();
  Vector2? getRandomVectorOffset() {
    return (Vector2.random(_random) - Vector2(0.5, -1)) * 300; //scale factor
  }

  Enemy({
    SpriteAnimation? animation,
    Vector2? size,
    Vector2? position,
  }) : super(animation: animation, size: size, position: position);

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(-1, 0) * speed * dt;

    if (gameRef.stageManager.stage > 3) {
      if (position.x < gameRef.size.x / 3) {
        if (position.y < gameRef.size.y / 2) {
          position.y++;
        } else {
          position.y--;
        }
      }
    }

    if (x <= 0) gameRef.remove(this);
  }

  @override
  void onRemove() {
    super.onRemove();
    shouldRemove = true;
  }

  // hit
  void hitToPlayer(Player player) async {
    // ignore: deprecated_member_use
    gameRef.camera.shake(duration: 0.1, intensity: 5);
    if (!hitChecking) {
      hitChecking = true;
      player.life = player.life - power;

      if (player.life >= 0) {
        gameRef.lifeComponent.text = "X${gameRef.player.life}";
      }

      if (player.life <= 0) {
        await gameRef.gameOver();
        return;
      }
    }

    final particleComponent = ParticleSystemComponent(
        particle: Particle.generate(
            count: 20,
            lifespan: 0.5,
            generator: (i) => AcceleratedParticle(
                acceleration: getRandomVectorOffset(),
                speed: getRandomVectorOffset(),
                position: (position.clone() + Vector2(0, size.y / 3)),
                child: CircleParticle(
                    radius: 2, paint: Paint()..color = Colors.orange))));
    gameRef.add(particleComponent);
  }

  void hitByBullet(Bullet bullet) {
    gameRef.remove(bullet);
    life = life - bullet.power;
    gameRef.updateScore(scoreWhenKilled);

    if (life <= 0) {
      gameRef.createPowerUps(this);
      gameRef.remove(this);
    }
    // if (!hitChecking) {
    //   hitChecking = true;
    //   life = life - bullet.power;

    //   gameRef.updateScore(scoreWhenKilled);

    //   if (life <= 0) {
    //     gameRef.createPowerUps(this);
    //     gameRef.remove(this);
    //   }
    //   Future.delayed(const Duration(milliseconds: 100), () {
    //     hitChecking = false;
    //   });
    // }

    // particles effect
    final particleComponent = ParticleSystemComponent(
        particle: Particle.generate(
            count: 20,
            lifespan: 0.1,
            generator: (i) => AcceleratedParticle(
                acceleration: getRandomVectorOffset(),
                speed: getRandomVectorOffset(),
                position: (position.clone() + Vector2(0, size.y / 3)),
                child: CircleParticle(
                    radius: 2, paint: Paint()..color = Colors.green))));
    gameRef.add(particleComponent);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
    } else if (other is Bullet) {
      hitByBullet(other);
    }
  }
}
