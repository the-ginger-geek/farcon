import 'dart:math';
import 'dart:ui';

import 'package:farcon/positioner.dart';
import 'package:farcon/world/default_map.dart';
import 'package:farcon/world/utils/map_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/image_composition.dart';

class Farcon extends BaseGame with HorizontalDragDetector, VerticalDragDetector, MapBuilder {

  late DefaultMap defaultMap;
  late Positioner positioner;

  Offset dragDown = Offset(0, 0);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadMap();
    camera.worldToScreen(viewport.effectiveSize);
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) => dragDown = details.globalPosition;

  @override
  void onHorizontalDragCancel() => defaultMap.stopMoving();

  @override
  void onVerticalDragStart(DragStartDetails details) => dragDown = details.globalPosition;

  @override
  void onVerticalDragCancel() => defaultMap.stopMoving();

  @override
  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (details.globalPosition.dx < dragDown.dx) {
      defaultMap.moveRight();
    } else if (details.globalPosition.dx > dragDown.dx) {
      defaultMap.moveLeft();
    }
  }
  @override
  void onVerticalDragUpdate(DragUpdateDetails details) {
    if (details.globalPosition.dy < dragDown.dy) {
      defaultMap.moveDown();
    } else if (details.globalPosition.dy > dragDown.dy) {
      defaultMap.moveUp();
    }
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    dragDown = Offset(0, 0);
    defaultMap.stopMoving();
  }

  @override
  void onVerticalDragEnd(DragEndDetails details) {
    dragDown = Offset(0, 0);
    defaultMap.stopMoving();
  }

  Future _loadMap() async {
    add(
        positioner = Positioner()
          ..x = 200
          ..y = 200
          ..width = 50
          ..height = 100
    );
    add(
      defaultMap = DefaultMap()
        ..x = x
        ..y = y,
    );
  }
}
