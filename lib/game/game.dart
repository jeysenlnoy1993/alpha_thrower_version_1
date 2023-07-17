// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:alpha_thrower_version_1/enemy/enemy.dart';
import 'package:alpha_thrower_version_1/enemy/enemy_manager.dart';
import 'package:alpha_thrower_version_1/game/Pause/PauseButton.dart';
import 'package:alpha_thrower_version_1/game/Pause/Pause_menu.dart';
import 'package:alpha_thrower_version_1/game/Stage/stage_manager.dart';
import 'package:alpha_thrower_version_1/game/game_joystick.dart';
import 'package:alpha_thrower_version_1/game/gameover/game_over.dart';
import 'package:alpha_thrower_version_1/player/player.dart';
import 'package:alpha_thrower_version_1/powerups/task_object.dart';
import 'package:alpha_thrower_version_1/projectile/bullet.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame
    with PanDetector, HasCollisionDetection, CollisionCallbacks {
  int score = 0;
  int stage = 1;
  late TextComponent lifeComponent;
  late TextComponent scoreComponent;
  late TextComponent stageComponent;

  Player player = Player();
  late final GameJoystick joystick;
  late SpriteAnimation spaPlayer1;
  late SpriteAnimation bulletAnimation;
  late SpriteAnimation objectTaskAnimation;
  late SpriteAnimation object1UpAnimation;
  late SpriteAnimation enemyAnimation;
  String player1Path = 'player/player1.png';
  String playerLifePath = 'player/heart.png';
  String enemy1Path = 'enemy/enemy1.png';
  String buttonPath = 'buttons/buttons.png';
  String bulletPath = 'projectiles/bullet.png';
  String objectPath = 'objects/task/quest_item_64x64px/';

  late SpriteComponent playerLife;

  late EnemyManager enemyManager;
  late StageManager stageManager;

  static const String lifeStr = '1UP';
  static const String taskItemStr = 'TASKITEM';

  List<StageItem> powerUpList = [];

  @override
  FutureOr<void> onLoad() async {
    // POWER UPS
    powerUpList.addAll([
      StageItem(lifeStr, 0.5),
      StageItem(taskItemStr, 0.5),
    ]);

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
    // OBJECTS
    // Task Item
    final spriteSheetTaskItem = SpriteSheet(
      image: await images.load('${objectPath}taskitem.png'),
      srcSize: Vector2(40, 40),
    );
    // Life Bonus
    final spriteSheet1up = SpriteSheet(
      image: await images.load('${objectPath}1up.png'),
      srcSize: Vector2(40, 40),
    );

    spaPlayer1 = spriteSheet.createAnimation(
        row: 0, stepTime: 0.1, from: 3, to: 9, loop: true);
    bulletAnimation = spriteSheetBullet.createAnimation(
        row: 0, stepTime: 0.2, from: 0, to: 5);
    enemyAnimation = spriteSheetEnemy.createAnimation(
        row: 0, stepTime: 0.1, from: 0, to: 3, loop: true);

    objectTaskAnimation = spriteSheetTaskItem.createAnimation(
        row: 0, stepTime: 0.1, from: 0, to: 5);

    object1UpAnimation =
        spriteSheet1up.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 5);

    player = Player(
        animation: spaPlayer1,
        // animation: spaPlayer1Damage,
        size: Vector2(size.x * 0.08, size.y * 0.10),
        position: Vector2(size.x / 2, size.y / 2));

    // joystick
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

    // Game Manager
    // ENEMY
    enemyManager = EnemyManager();

    // STAGE
    stageManager = StageManager(startStage: stage);

    // MISC
    playerLife = SpriteComponent(
        sprite: spriteSheetLife.getSpriteById(0),
        position: Vector2(5, 12),
        size: Vector2(16, 16));

    lifeComponent = TextComponent(
        text: "X${player.life}",
        position: Vector2(25, 10),
        textRenderer: TextPaint(style: TextStyle(fontSize: size.y * 0.04)));

    // Score
    scoreComponent = TextComponent(
        text: "Score: $score",
        position: Vector2(55, 10),
        textRenderer: TextPaint(style: TextStyle(fontSize: size.y * 0.04)));

    // level
    stageComponent = TextComponent(
        text: "Stage: $stage",
        position: Vector2(30, 45),
        textRenderer: TextPaint(style: TextStyle(fontSize: size.y * 0.04)));

    // Hit box
    final ShapeHitbox hitbox = RectangleHitbox();
    player.add(hitbox);

    await add(playerLife);
    await add(lifeComponent);
    await add(scoreComponent);
    await add(enemyManager);
    await add(flipButton);
    await add(joystick);
    await add(player);
  }

  updateScore(int enemyPoints) {
    score += enemyPoints;
    scoreComponent.text = "Score: $score";
  }

  gameOver() {
    overlays.remove(PauseButton.iD);
    overlays.remove(PauseMenu.iD);
    overlays.add(GameOverMenu.iD);
    Future.delayed(const Duration(milliseconds: 500), () {
      pauseEngine();
    });
  }

  shoot() async {
    final playerCenterX = player.position.x + player.size.x / 2;
    final bulletSize = player.size * 0.30;
    final bulletStartPosition = Vector2(playerCenterX - bulletSize.x / 2,
        player.position.y + player.size.y / 2 - bulletSize.y / 2);

    Bullet bullet = Bullet(
      animation: bulletAnimation,
      size: bulletSize,
      position: bulletStartPosition,
    );
    final ShapeHitbox hitbox = CircleHitbox();
    bullet.add(hitbox);
    add(bullet);
  }

  pauseGame() {
    if (player.life <= 0) return;
    pauseEngine();
    overlays.add(PauseMenu.iD);
  }

  generateObject({required double probabilityInPercentage}) {
    // 0.0  to 1.0
    // 0% to 100%
    final random = Random();
    return random.nextDouble() < probabilityInPercentage;
  }

  createPowerUps(Enemy enemy) async {
    var ups = powerUpList.getRandom();
    bool createInstance =
        generateObject(probabilityInPercentage: ups!.probability);
    if (!createInstance) return;

    switch (ups.name) {
      case lifeStr:
        TaskObject oneUp = TaskObject(
            animation: object1UpAnimation,
            size: player.size / 2,
            position: enemy.position,
            type: lifeStr);
        final ShapeHitbox hitbox = CircleHitbox();
        oneUp.add(hitbox);
        add(oneUp);
        break;
      case taskItemStr:
        TaskObject taskObject = TaskObject(
            animation: objectTaskAnimation,
            size: player.size / 2,
            position: enemy.position,
            type: taskItemStr);
        final ShapeHitbox hitbox = CircleHitbox();
        taskObject.add(hitbox);
        add(taskObject);
        break;
    }
  }

  // app life cycle
  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);

    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        print(player.life);
        pauseGame();
        break;
      case AppLifecycleState.detached:
        pauseGame();

        break;
    }
  }
}

extension RandomListItem<T> on List<T> {
  T? getRandom() => isEmpty
      ? null
      : length == 1
          ? first
          : this[Random().nextInt(length)];
}

class StageItem {
  final name;
  final probability;
  StageItem(this.name, this.probability);
}
