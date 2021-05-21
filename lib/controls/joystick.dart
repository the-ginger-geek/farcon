import 'package:farcon/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Control extends JoystickComponent {
  Control(Farcon farcon)
      : super(
      gameRef: farcon,
      priority: 9,
      directional: JoystickDirectional(),
      actions: [JoystickAction(
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
        JoystickAction(
          actionId: 3,
          margin: const EdgeInsets.only(bottom: 50, right: 120),
          enableDirection: true,
        ),
      ]
  );
}
