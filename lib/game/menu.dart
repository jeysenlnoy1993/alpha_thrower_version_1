import 'package:alpha_thrower_version_1/game/game.dart';
import 'package:alpha_thrower_version_1/game/game_world.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final game = MyGame();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BounceInDown(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  "Alpha Thrower",
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
            const SizedBox(height: 20),
            FadeIn(
              delay: const Duration(seconds: 1),
              child: FlipInY(
                delay: const Duration(seconds: 1),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameScreen()),
                    );
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
                  onPressed: () {},
                  child: Text("Settings"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
