import 'dart:math';

import 'package:alpha_thrower_version_1/game/Stage/stage.dart';
import 'package:flame/components.dart';

import '../game.dart';

class StageManager extends Component with HasGameRef<MyGame> {
  Random random = Random();
  int stage = 0;
  final int _pointsMultiplier = 1;
  late Stage currentStage;

  StageManager({required this.stage}) : super() {
    currentStage = Stage(
      level: stage,
    );
    currentStage.requiredPoints = stage * _pointsMultiplier;
    currentStage.task =
        "You are assigned to gather ${currentStage.requiredPoints} magic stones.";
  }

  checkTasks() {
    if (currentStage.requiredPoints == gameRef.player.collectedPoints) {
      gameRef.pauseEngine();
      gameRef.nextLevel();
    }
  }
}
