import 'package:farcon/game/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Control extends JoystickComponent {
  Control(Farcon farcon)
      : super(
          gameRef: farcon,
          priority: 900000000000,
          directional: JoystickDirectional(),
          actions: [
            JoystickAction(
              actionId: 1,
              margin: const EdgeInsets.all(50),
              color: const Color(0xFF0000FF),
            ),
            JoystickAction(
              actionId: 2,
              color: const Color(0xFF00FF00),
              margin: const EdgeInsets.only(
                right: 50,
                bottom: 120,
              ),
            ),
          ],
        );
}
