import 'package:farcon/characters/character.dart';
import 'package:farcon/constants/character_constants.dart';
import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/controls/joystick.dart';
import 'package:farcon/world/grassy_block.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/joystick.dart';
import 'package:flame/keyboard.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';

import 'constants/asset_paths.dart';

class Farcon extends BaseGame
    with HasDraggableComponents, KeyboardEvents, MapUtils {
  Vector2 dragDown = Vector2(0, 0);
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

    camera.snapTo(Vector2(
      -viewport.effectiveSize.x / 2,
      -viewport.effectiveSize.y / 3,
    ));
  }


  // void onDragUpdate(int pointerId, DragUpdateDetails details) {
  //   super.onDragUpdate(pointerId, details);
  //   joystick.onDragUpdate(pointerId, details);
  // }

  // @override
  // void onDragStart(int pointerId, Vector2 details) {
  //   dragDown = Vector2(
  //     camera.position.x + details.x,
  //     camera.position.y + details.y,
  //   );
  // }
  //
  // @override
  // void onDragUpdate(int pointerId, DragUpdateDetails details) {
  //   final x = dragDown.x - details.globalPosition.dx;
  //   final y = dragDown.y - details.globalPosition.dy;
  //   camera.snapTo(Vector2(x, y));
  //   femaleCharacter.updateState(CharacterState.DANCE);
  // }
  //
  // @override
  // void onDragEnd(int pointerId, DragEndDetails details) {
  //   femaleCharacter.updateState(CharacterState.IDLE);
  // }

  void _loadMap() {
    final blockSize = MapConstants.mapRenderBlockSize;
    final mapEdgeX = blockSize * 1;
    final mapEdgeY = blockSize * 1;

    for (double x = 0; x < mapEdgeX; x += blockSize) {
      for (double y = 0; y < mapEdgeY; y += blockSize) {
        add(GrassyBlock(
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
