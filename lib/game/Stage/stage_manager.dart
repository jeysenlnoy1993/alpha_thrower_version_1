import 'dart:math';

import 'package:alpha_thrower_version_1/game/Stage/stage.dart';
import 'package:flame/components.dart';

import '../game.dart';

class StageManager extends Component with HasGameRef<MyGame> {
  Random random = Random();
  int stage = 1;
  final double _pointsMultiplier = 0.5;
  final double _quest = 3;
  late Stage currentStage;

  StageManager({required this.stage}) : super() {
    currentStage = Stage(
      level: stage,
    );
    currentStage.requiredPoints =
        (_quest + (stage * _pointsMultiplier).round()).round();
    currentStage.task =
        "You are assigned to gather ${currentStage.requiredPoints} magic stones.";
  }

  nextStage() {
    stage++;
    currentStage.requiredPoints =
        (_quest + (stage * _pointsMultiplier).round()).round();
    currentStage.task =
        "You are assigned to gather ${currentStage.requiredPoints} magic stones.";
    // double gameSpeed = gameRef.enemyManager.timer.limit;
    // gameSpeed = gameSpeed - 0.03;
    // if (gameSpeed < 0.5) gameSpeed = 0.5;
    // gameRef.enemyManager.timer.limit = gameSpeed;
  }
}
