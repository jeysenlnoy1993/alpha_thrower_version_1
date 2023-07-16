import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/src/events/messages/drag_update_event.dart';
import 'package:flutter/painting.dart';

class GameJoystick extends JoystickComponent {
  GameJoystick()
      : super(
          knob: CircleComponent(
            radius: 20,
            paint: BasicPalette.white.withAlpha(150).paint(),
          ),
          background: CircleComponent(
            radius: 50,
            paint: BasicPalette.white.withAlpha(50).paint(),
          ),
          margin: const EdgeInsets.only(left: 50, bottom: 50),
        );
}
