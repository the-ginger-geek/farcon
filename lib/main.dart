import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'game.dart';

void main() {
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