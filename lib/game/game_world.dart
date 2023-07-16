import 'package:alpha_thrower_version_1/game/Pause/PauseButton.dart';
import 'package:alpha_thrower_version_1/game/Pause/Pause_menu.dart';
import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:alpha_thrower_version_1/main.dart';
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
              PauseButton.iD: (BuildContext context, MyGame gameRef) =>
                  PauseButton(
                    gameRef: gameRef,
                  ),
              PauseMenu.iD: (BuildContext context, MyGame gameRef) => PauseMenu(
                    gameRef: gameRef,
                  ),
            }, game: game)));
  }
}
