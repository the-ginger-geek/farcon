
import 'dart:ui';

import 'package:farcon/game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Positioner extends PositionComponent with HasGameRef<Farcon> {
  static const double SPEED = 300;

  int _direction = 0;

  void moveRight() { _direction = 1; }
  void moveLeft() { _direction = -1; }
  void stopMoving() { _direction = 0; }

  @override
  void update(double dt) {
    super.update(dt);
    // Calculates how much we are going to move on this iteration
    final step = _direction * SPEED * dt;

    gameRef.camera.cameraSpeed = SPEED;
    if (_direction > 0) {
      x += step;
      if (gameRef.viewport.effectiveSize.x > x) {
        gameRef.camera.position.x += step;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(toRect(), BasicPalette.blue.paint());
  }
}