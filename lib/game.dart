import 'package:farcon/world/default_map.dart';
import 'package:farcon/world/map_trees.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/image_composition.dart';

class Farcon extends BaseGame with MultiTouchDragDetector {
  late DefaultMap defaultMap;

  Vector2 dragDown = Vector2(0, 0);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadMap();
    camera.screenToWorld(defaultMap.size);
  }

  @override
  void onDragStart(int pointerId, Vector2 details) {
    dragDown = Vector2(
      camera.position.x + details.x,
      camera.position.y + details.y,
    );
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateDetails details) {
    final x = dragDown.x - details.globalPosition.dx;
    final y = dragDown.y - details.globalPosition.dy;
    camera.snapTo(Vector2(x, y));
  }

  @override
  void onDragEnd(int pointerId, DragEndDetails details) {}

  Future _loadMap() async {
    add(defaultMap = DefaultMap());
    add(MapTrees());
  }
}
