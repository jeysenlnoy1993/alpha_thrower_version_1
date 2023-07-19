import 'dart:async';
import 'dart:math';

import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'enemy.dart';

class EnemyManager extends Component with HasGameRef<MyGame> {
  late Timer timer;
  late SpriteAnimation enemyAnimation;
  Random random = Random();
  EnemyManager() : super() {
    timer = Timer(1.5, onTick: _spawnEnemy, repeat: true);
  }

  void _spawnEnemy() {
    Vector2 enemySize = Vector2(gameRef.size.x * 0.08, gameRef.size.y * 0.10);

    // ENEMY
    // LEVEL 1
    List levelEnemy = [
      {
        'level': 1,
        'animation_from': 0,
        'animation_to': 3,
        'life': 2,
        'power': 1,
        'speed': 150.00,
        'size': enemySize * 0.8,
      },

      // red
      {
        'level': 2,
        'animation_from': 4,
        'animation_to': 7,
        'life': 4,
        'power': 1,
        'speed': 180.00,
        'size': enemySize * 1.2,
      },
      // big enemy level 1 slow
      {
        'level': 3,
        'animation_from': 0,
        'animation_to': 3,
        'life': 10,
        'power': 1,
        'speed': 50.00,
        'size': enemySize * 2.5,
      },
      //small fast
      {
        'level': 4,
        'animation_from': 0,
        'animation_to': 3,
        'life': 1,
        'power': 1,
        'speed': 260.00,
        'size': enemySize * 0.5,
      },
      // fast red
      {
        'level': 5,
        'animation_from': 4,
        'animation_to': 7,
        'life': 1,
        'power': 1,
        'speed': 290.00,
        'size': enemySize * 0.5,
      },
    ];

    final int stage = gameRef.stageManager.stage;

    levelEnemy = levelEnemy.where((item) => item['level'] <= stage).toList();

    var enemyMap = levelEnemy.getRandom();

    // probability check
    double probabilty = stage.toDouble() / enemyMap['level'];

    bool create = gameRef.generateObject(probabilityInPercentage: probabilty);
    if (!create) return;

    // set enemy sprite animation
    enemyAnimation = gameRef.spriteSheetEnemy.createAnimation(
        row: 0,
        stepTime: 0.1,
        from: enemyMap['animation_from'],
        to: enemyMap['animation_to'],
        loop: true);

    Enemy enemy = Enemy(
      animation: enemyAnimation,
      size: enemySize,
      position: Vector2.zero(),
    );

    // set enemy property

    enemy.life = enemyMap['life'];
    enemy.speed = enemyMap['speed'];
    enemy.power = enemyMap['power'];
    enemy.size = enemyMap['size'];

    Vector2 randPos = Vector2(
        gameRef.size.x + enemySize.x, random.nextDouble() * gameRef.size.y);

    enemy.position = randPos;
    // check top
    if (enemy.position.y < 0) enemy.position.y = 0;
    // check bottom
    if ((enemy.position.y + enemy.size.y) > gameRef.size.y) {
      enemy.position.y = gameRef.size.y - enemySize.y;
    }

    // set enemy hitbox
    final ShapeHitbox hitbox = CircleHitbox();
    enemy.add(hitbox);

    // add enemy in game
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    super.onMount();
    timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }
}
