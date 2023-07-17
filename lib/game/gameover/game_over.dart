import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:alpha_thrower_version_1/game/game_world.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class GameOverMenu extends StatelessWidget {
  static const String iD = 'GameOverMenuId';
  final MyGame gameRef;
  const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);

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
                "Game Over",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 50,
                    shadows: [
                      const Shadow(
                          blurRadius: 20.0,
                          color: Colors.white,
                          offset: Offset(0, 0))
                    ]),
              ),
            ),
          ),
          FlipInY(
            delay: const Duration(seconds: 1),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              },
              child: Text("Restart"),
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
    );
  }
}
