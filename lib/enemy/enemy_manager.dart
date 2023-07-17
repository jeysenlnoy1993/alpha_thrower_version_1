import 'dart:async';
import 'dart:math';

import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'enemy.dart';

class EnemyManager extends Component with HasGameRef<MyGame> {
  late Timer _timer;
  Random random = Random();
  EnemyManager() : super() {
    _timer = Timer(1, onTick: _spawnEnemy, repeat: true);
  }

  void _spawnEnemy() {
    Vector2 enemySize = Vector2(gameRef.size.x * 0.08, gameRef.size.y * 0.10);
    Vector2 randPos = Vector2(
        gameRef.size.x + enemySize.x, random.nextDouble() * gameRef.size.y);

    if (randPos.y < 0) randPos.y = 0;

    if (randPos.y + enemySize.y > gameRef.size.y) {
      randPos.y = gameRef.size.y - enemySize.y;
    }

    // ENEMY
    Enemy enemy = Enemy(
      animation: gameRef.enemyAnimation,
      size: enemySize,
      position: randPos,
    );
    final ShapeHitbox hitbox = CircleHitbox();
    enemy.add(hitbox);
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }
}
