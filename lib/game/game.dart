// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:alpha_thrower_version_1/enemy/enemy.dart';
import 'package:alpha_thrower_version_1/enemy/enemy_manager.dart';
import 'package:alpha_thrower_version_1/game/game_joystick.dart';
import 'package:alpha_thrower_version_1/player/player.dart';
import 'package:alpha_thrower_version_1/projectile/bullet.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with PanDetector {
  int score = 0;
  late TextComponent scoreComponent;

  Player player = Player();
  late final GameJoystick joystick;
  late SpriteAnimation spaPlayer1;
  late SpriteAnimation bulletAnimation;
  late SpriteAnimation enemyAnimation;
  String player1Path = 'player/player1.png';
  String playerLifePath = 'player/heart.png';
  String enemy1Path = 'enemy/enemy1.png';
  String buttonPath = 'buttons/buttons.png';
  String bulletPath = 'projectiles/bullet.png';

  late SpriteComponent playerLife;

  late EnemyManager enemyManager;

  // Joystick

  @override
  FutureOr<void> onLoad() async {
    //PLAYER
    final spriteSheet = SpriteSheet(
      image: await images.load(player1Path),
      srcSize: Vector2(128, 110),
    );
    //PLAYER LIFE
    final spriteSheetLife = SpriteSheet(
      image: await images.load(playerLifePath),
      srcSize: Vector2(32, 32),
    );
    // BUTTON
    final spriteSheetButton = SpriteSheet(
      image: await images.load(buttonPath),
      srcSize: Vector2(140, 150),
    );
    // BULLET
    final spriteSheetBullet = SpriteSheet(
      image: await images.load(bulletPath),
      srcSize: Vector2(40, 40),
    );
    // ENEMY
    final spriteSheetEnemy = SpriteSheet(
      image: await images.load(enemy1Path),
      srcSize: Vector2(233, 120),
    );

    spaPlayer1 = spriteSheet.createAnimation(
        row: 0, stepTime: 0.1, from: 3, to: 9, loop: true);
    bulletAnimation = spriteSheetBullet.createAnimation(
        row: 0, stepTime: 0.2, from: 0, to: 5);
    enemyAnimation = spriteSheetEnemy.createAnimation(
        row: 0, stepTime: 0.1, from: 0, to: 3, loop: true);

    player = Player(
        animation: spaPlayer1,
        // animation: spaPlayer1Damage,
        size: Vector2(size.x * 0.08, size.y * 0.10),
        position: Vector2(size.x / 2, size.y / 2));

    // joystick

    // add components
    joystick = GameJoystick();
    player.addJoystickComponent(joystick);

    // A button with margin from the edge of the viewport that flips the
    // rendering of the player on the X-axis.
    final flipButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: spriteSheetButton.getSpriteById(0),
        size: Vector2.all(80),
      ),
      buttonDown: SpriteComponent(
        sprite: spriteSheetButton.getSpriteById(0),
        size: Vector2.all(70),
      ),
      margin: const EdgeInsets.only(
        right: 80,
        bottom: 60,
      ),
      // onPressed: player.flipHorizontally,
      onPressed: () {
        shoot();
      },
    );

    enemyManager = EnemyManager();

    for (var i = 0; i < player.life; i++) {
      playerLife = SpriteComponent(
        sprite: spriteSheetLife.getSpriteById(0),
        position: Vector2(5 + 32 * i.toDouble(), 5),
        key: ComponentKey.named("life$i"),
      );
      add(playerLife);
    }

    scoreComponent = TextComponent(
        text: "Score: $score",
        position: Vector2(size.x, 45),
        textRenderer: TextPaint(style: TextStyle(fontSize: size.y * 0.04)));
    scoreComponent.position.x = size.x - scoreComponent.x;
    add(scoreComponent);

    add(enemyManager);
    await add(flipButton);
    await add(joystick);
    await add(player);

    return super.onLoad();
  }

  updateScore(int enemyPoints) {
    score += enemyPoints;
    scoreComponent.text = "Score: $score";
    scoreComponent.size = Vector2(2, 30);
  }

  gameOver() {
    print('game over');
    pauseEngine();
  }

  shoot() async {
    final playerCenterX = player.position.x + player.size.x / 2;
    final bulletSize = player.size * 0.40;
    final bulletStartPosition = Vector2(playerCenterX - bulletSize.x / 2,
        player.position.y + player.size.y / 2 - bulletSize.y / 2);

    Bullet bullet = Bullet(
      animation: bulletAnimation,
      size: bulletSize,
      position: bulletStartPosition,
    );
    add(bullet);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // look for all bullets
    final bullets = children.whereType<Bullet>();
    for (var enemy in children.whereType<Enemy>()) {
      if (enemy.shouldRemove) continue;

      if (enemy.hitChecking) continue;
      if (enemy.containsPoint(player.absoluteCenter)) {
        enemy.hitToPlayer(player);
        break;
      }

      for (var bullet in bullets) {
        if (bullet.shouldRemove) continue;
        if (enemy.hitChecking) continue;
        if (enemy.containsPoint(bullet.absoluteCenter)) {
          enemy.hitByBullet(bullet);
          break;
        }
      }
    }
  }
}
