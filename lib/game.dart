import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/constants/strings.dart';
import 'package:farcon/world/default_map.dart';
import 'package:farcon/world/map_objects.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/image_composition.dart';

import 'world/selector.dart';

class Farcon extends BaseGame
    with MultiTouchDragDetector, MouseMovementDetector, MapUtils {
  late DefaultMap defaultMap;
  late Selector selector;

  Vector2 dragDown = Vector2(0, 0);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // debugMode = true;
    await _loadMap();

    final selectorImage = await images.load(Strings.selectorSprite);
    add(selector = Selector(selectorImage));
    print('Viewport [size: ${viewport.effectiveSize}]');

    camera.snapTo(Vector2(
      -viewport.effectiveSize.x / 2,
      -viewport.effectiveSize.y / 3,
    ));
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

  @override
  void onMouseMove(PointerHoverEvent event) {
    final screenPosition = event.position;
    final cursorPosition = Vector2(screenPosition.dx + camera.position.x,
        screenPosition.dy + camera.position.y);
    _moveSelector(cursorPosition);
  }

  void _moveSelector(Vector2 cursorPosition) {
    final selectorPosition = Vector2(cursorPosition.x - selector.width / 2,
        cursorPosition.y - selector.height / 2);
    final block = defaultMap.getBlock(selectorPosition);
    bool hasBlock = defaultMap.containsBlock(block);
    selector.show = hasBlock;

    final position = cartToIso(Vector2(block.x.toDouble(), block.y.toDouble()));
    selector.position.setFrom(position);
  }

  Future _loadMap() async {
    add(defaultMap = DefaultMap(loadComplete: () {
      add(MapObjects(
        sprites: Strings.grassSprites,
        seedCountMax: MapConstants.grassCountMax,
        seedCountMin: MapConstants.grassCountMin,
        imageSize: MapConstants.grassImageSize,
        noDrawCoordinates: defaultMap.waterCoordinates,
        centerImageTo: CenterTo.CENTER,
      ));
      add(MapObjects(
        sprites: Strings.treeSprites,
        seedCountMax: MapConstants.treeCountMax,
        seedCountMin: MapConstants.treeCountMin,
        imageSize: MapConstants.treeImageSize,
        noDrawCoordinates: defaultMap.waterCoordinates,
      ));
      add(MapObjects(
        sprites: Strings.flowerSprites,
        seedCountMax: MapConstants.flowerCountMax,
        seedCountMin: MapConstants.flowerCountMin,
        imageSize: MapConstants.flowerImageSize,
        noDrawCoordinates: defaultMap.waterCoordinates,
      ));
    }));
  }
}
