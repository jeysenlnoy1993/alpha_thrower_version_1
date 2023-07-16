import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:alpha_thrower_version_1/player/player.dart';
import 'package:flame/components.dart';

import '../projectile/bullet.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef<MyGame> {
  double speed = 250;
  int scoreWhenKilled = 100;
  bool shouldRemove = false;
  int life = 3;
  bool hitChecking = false;
  int power = 1;

  bool canTakeDamage = true;
  final cooldownDuration = const Duration(seconds: 1);
  Timer? cooldownTimer;

  Enemy({
    SpriteAnimation? animation,
    Vector2? size,
    Vector2? position,
  }) : super(animation: animation, size: size, position: position);

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(-1, 0) * speed * dt;
    if (x <= 0) gameRef.remove(this);
  }

  @override
  void onRemove() {
    super.onRemove();
    shouldRemove = true;
  }

  // hit
  void hitToPlayer(Player player) async {
    if (!hitChecking) {
      hitChecking = true;
      player.life = player.life - power;

      gameRef
          .findByKey(ComponentKey.named('life${player.life}'))!
          .removeFromParent();
      if (player.life <= 0) {
        await gameRef.gameOver();
      }
    }
  }

  void hitByBullet(Bullet bullet) {
    gameRef.remove(bullet);
    if (!hitChecking) {
      hitChecking = true;
      life = life - bullet.power;
      gameRef.updateScore(scoreWhenKilled);

      if (life <= 0) {
        gameRef.remove(this);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        hitChecking = false;
      });
    }
  }
}
