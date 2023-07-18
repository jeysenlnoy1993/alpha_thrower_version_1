import 'package:alpha_thrower_version_1/game/Pause/PauseButton.dart';
import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class StageMenu extends StatelessWidget {
  static const String iD = 'StageMenuId';
  final MyGame gameRef;
  const StageMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white.withOpacity(0.1),
        width: gameRef.size.x / 2,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BounceInDown(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  "Stage  ${gameRef.stageManager.stage}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      shadows: [
                        const Shadow(
                            blurRadius: 20.0,
                            color: Colors.white,
                            offset: Offset(0, 0))
                      ]),
                ),
              ),
            ),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  gameRef.stageManager.currentStage.task,
                  speed: const Duration(milliseconds: 50),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
            ),
            const SizedBox(height: 25),
            FadeIn(
              delay: const Duration(seconds: 1),
              child: FlipInY(
                delay: const Duration(seconds: 1),
                child: ElevatedButton(
                  onPressed: () async {
                    gameRef.restartGame();
                    gameRef.overlays.remove(StageMenu.iD);
                    gameRef.overlays.add(PauseButton.iD);
                  },
                  child: Text("Play"),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeIn(
              delay: const Duration(milliseconds: 1300),
              child: FlipInY(
                delay: const Duration(milliseconds: 1300),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Main Menu"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
