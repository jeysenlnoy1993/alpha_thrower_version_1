import 'package:alpha_thrower_version_1/game/Pause/Pause_menu.dart';
import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:flutter/material.dart';

class PauseButton extends StatelessWidget {
  static const String iD = 'PauseButtonId';
  final MyGame gameRef;
  const PauseButton({Key? key, required this.gameRef}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: TextButton(
          onPressed: () {
            gameRef.pauseEngine();
            gameRef.overlays.add(PauseMenu.iD);
          },
          child: const Icon(
            Icons.pause_rounded,
            color: Colors.white,
          )),
    );
  }
}
