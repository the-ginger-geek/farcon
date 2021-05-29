import 'package:farcon/game/world/game_map.dart';
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
import '../constants/asset_paths.dart';
import '../game/controls/joystick.dart';
import '../game/world/utils/map_utils.dart';

class Farcon extends BaseGame
    with HasDraggableComponents, KeyboardEvents, MapUtils {
  Vector2 dragDown = Vector2(0, 0);
  late GameMap gameMap;
  late Character character;
  late JoystickComponent joystick;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(gameMap = GameMap(callback: (mapCenter) {
      final characterPosition = cartToIso(mapCenter);
      character = Character(
        characterPath: AssetPaths.robot,
        characterHeight: CharacterConstants.characterSheetHeight /
            CharacterConstants.characterSheetRowCount,
        characterWidth: CharacterConstants.characterSheetWidth /
            CharacterConstants.characterSheetColumnCount,
        characterPosition: Vector2(
          characterPosition.x,
          characterPosition.y,
        ),
      );

      joystick = Control(this)..addObserver(character);
      add(joystick);
      add(character);

      camera.followComponent(character);
    }));
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
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

  @override
  void onKeyEvent(RawKeyEvent event) {
    if (event.isKeyPressed(event.logicalKey)) {
      character.keyMove(event.logicalKey.keyLabel);
      gameMap.updateMap();
    } else {
      character.keyMove('');
    }
  }
}
