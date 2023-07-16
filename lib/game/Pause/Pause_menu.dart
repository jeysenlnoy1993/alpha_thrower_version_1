import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  static const String iD = 'PauseMenuId';
  final MyGame gameRef;
  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BounceInDown(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                "Alpha Thrower",
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
          FadeIn(
            delay: const Duration(seconds: 1),
            child: FlipInY(
              delay: const Duration(seconds: 1),
              child: ElevatedButton(
                onPressed: () {
                  gameRef.resumeEngine();
                  gameRef.overlays.remove(PauseMenu.iD);
                },
                child: Text("Resume"),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FadeIn(
            delay: const Duration(milliseconds: 1300),
            child: FlipInY(
              delay: const Duration(milliseconds: 1300),
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Main Menu"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
