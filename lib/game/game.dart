import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flame/joystick.dart';
import 'package:flame/keyboard.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';

import '../game/characters/character.dart';
import '../constants/character_constants.dart';
import '../constants/map_constants.dart';
import '../constants/asset_paths.dart';
import '../game/controls/joystick.dart';
import '../game/world/foresty_block.dart';
import '../game/world/utils/map_utils.dart';

class Farcon extends BaseGame
    with HasDraggableComponents, KeyboardEvents, MapUtils {
  Vector2 dragDown = Vector2(0, 0);
  late ForestyBlock grassyBlock;
  late Character character;
  late JoystickComponent joystick;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // debugMode = true;
    _loadMap();
    
    character = Character(
      characterPath: AssetPaths.robot,
      characterHeight: CharacterConstants.characterSheetHeight / CharacterConstants.characterSheetRowCount,
      characterWidth: CharacterConstants.characterSheetWidth / CharacterConstants.characterSheetColumnCount,
    );

    joystick = Control(this)..addObserver(character);
    add(character);
    add(joystick);

    camera.followComponent(character);
  }

  void onDragUpdate(int pointerId, DragUpdateInfo details) {
    super.onDragUpdate(pointerId, details);
    joystick.onDragUpdate(pointerId, details);
  }


  // @override
  // void onDragUpdate(int pointerId, DragUpdateInfo details) {
  //   super.onDragUpdate(pointerId, details);
  //   final x = dragDown.x - details.eventPosition.global.x;
  //   final y = dragDown.y - details.eventPosition.global.y;
  //   camera.snapTo(Vector2(x, y));
  // }
  //
  // @override
  // void onDragStart(int pointerId, DragStartInfo info) {
  //   super.onDragStart(pointerId, info);
  //   dragDown = Vector2(
  //     camera.position.x + info.eventPosition.global.x,
  //     camera.position.y + info.eventPosition.global.y,
  //   );
  // }

  void _loadMap() {
    final blockSize = MapConstants.mapRenderBlockSize;
    final mapEdgeX = blockSize * 5.0;
    final mapEdgeY = blockSize * 5.0;

    for (double x = 0; x < mapEdgeX; x += blockSize) {
      for (double y = 0; y < mapEdgeY; y += blockSize) {
        add(grassyBlock = ForestyBlock(
          leftTop: Vector2(x, y),
          blockSize: blockSize,
        ));
      }
    }
  }

  @override
  void onKeyEvent(RawKeyEvent event) {
    if (event.isKeyPressed(event.logicalKey)) {
      camera.followComponent(character);
      character.keyMove(event.logicalKey.keyLabel);
    } else {
      camera.resetMovement();
      character.keyMove('');
    }

  }
}
