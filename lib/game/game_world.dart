import 'package:alpha_thrower_version_1/game/Pause/PauseButton.dart';
import 'package:alpha_thrower_version_1/game/Pause/Pause_menu.dart';
import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:alpha_thrower_version_1/game/gameover/game_over.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameScreen extends StatelessWidget {
  final game = MyGame();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            onWillPop: () async => false,
            child: GameWidget(initialActiveOverlays: const [
              PauseButton.iD,
            ], overlayBuilderMap: {
              // REGISTER OVERLAY WIDGETS HERE
              PauseButton.iD: (BuildContext context, MyGame gameRef) =>
                  PauseButton(
                    gameRef: gameRef,
                  ),
              PauseMenu.iD: (BuildContext context, MyGame gameRef) => PauseMenu(
                    gameRef: gameRef,
                  ),
              GameOverMenu.iD: (BuildContext context, MyGame gameRef) =>
                  GameOverMenu(
                    gameRef: gameRef,
                  ),
            }, game: game)));
  }
}
