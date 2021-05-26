import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'dependency_injection/service_locator.dart';
import 'game/game.dart';

void main() {
  configureDependencies();

  final myGame = Farcon();
  runApp(
    GameWidget(
      game: myGame,
      backgroundBuilder: (context) {
        return Container(color: Colors.amber);
      },
      overlayBuilderMap: {
        'PauseMenu': (ctx, _) {
          return Text('A pause menu');
        },
      },
    ),
  );
}