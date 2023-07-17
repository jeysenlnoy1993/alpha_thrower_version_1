import 'dart:math';

import 'package:alpha_thrower_version_1/game/Stage/stage.dart';
import 'package:flame/components.dart';

import '../game.dart';

class StageManager extends Component with HasGameRef<MyGame> {
  Random random = Random();
  int startStage = 0;
  final int _pointsMultiplier = 5;
  late Stage currentStage;

  StageManager({required this.startStage}) : super() {
    currentStage = Stage(
      level: startStage,
    );
  }

  void taskGenerator() {
    currentStage.requiredPoints = startStage * _pointsMultiplier;
    currentStage.task =
        "You are assigned to gather ${currentStage.requiredPoints} magic stones.";
  }

  checkTasks() {
    if (currentStage.requiredPoints == gameRef.player.acquiredPointsPerStage) {
      gameRef.pauseEngine();
      // gameRef.nextLevel();
    }
  }
}
