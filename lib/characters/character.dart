import 'dart:math';
import 'dart:ui';

import 'package:farcon/game.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Character extends PositionComponent
    with HasGameRef<Farcon>, MapUtils
    implements JoystickListener {
  static const speed = 32.0;

  final String characterPath;
  final double characterWidth;
  final double characterHeight;
  late SpriteSheet _spriteSheet;
  late SpriteAnimationComponent _spriteAnimationComponent;

  Vector2 characterPosition = Vector2(0, 0);
  double currentSpeed = 50;
  double movementAngle = 0;

  CharacterState characterState = CharacterState.IDLE;
  Direction direction = Direction.RIGHT;

  Character({
    required this.characterPath,
    required this.characterWidth,
    required this.characterHeight,
  });

  @override
  void update(double dt) {
    super.update(dt);
    if (characterState == CharacterState.MOVE) {
      _moveFromAngle(dt);
    }
  }

  @override
  Future<void> onLoad() async {
    _spriteSheet = SpriteSheet(
      image: await gameRef.images.load(characterPath),
      srcSize: Vector2(characterWidth, characterHeight),
    );

    _spriteAnimationComponent = SpriteAnimationComponent(
      position: position,
      animation: _getAnimation(_spriteSheet),
      size: Vector2(48.0, 64.0),
    );

    addChild(_spriteAnimationComponent);
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.down) {
      if (event.id == 1) {
        updateState(CharacterState.DANCE);
      }
      if (event.id == 2) {}
    } else if (event.event == ActionEvent.move) {
      if (event.id == 3) {
        movementAngle = event.angle;
      }
    } else if (event.event == ActionEvent.move) {
      if (event.id == 3) {
        _determineAngle(event.angle);
      }
    }
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    bool move = event.directional != JoystickMoveDirectional.idle;
    if (move) {
      _determineAngle(event.angle);
      updateState(CharacterState.MOVE);
      currentSpeed = speed * event.intensity;
    } else {
      updateState(CharacterState.IDLE);
    }
  }

  void _determineAngle(double angle) {
    movementAngle = angle;
    if (movementAngle < 0 && movementAngle > -1 ||
        movementAngle > 0 && movementAngle < 1) direction = Direction.RIGHT;
    if (movementAngle < 3 && movementAngle > 1 ||
        movementAngle > -3 && movementAngle < -1) direction = Direction.LEFT;
  }

  void keyMove(String key) {
    switch (key.toUpperCase()) {
      case 'A':
        {
          currentSpeed = speed;
          updateState(CharacterState.MOVE);
          direction = Direction.LEFT;
          break;
        }
      case 'D':
        {
          currentSpeed = speed;
          updateState(CharacterState.MOVE);
          direction = Direction.RIGHT;
          break;
        }
      case 'W':
        {
          currentSpeed = speed;
          updateState(CharacterState.MOVE);
          direction = Direction.UP;
          break;
        }
      case 'S':
        {
          currentSpeed = speed;
          updateState(CharacterState.MOVE);
          direction = Direction.DOWN;
          break;
        }
      default: updateState(CharacterState.IDLE);
    }

    updateState(characterState);
  }

  void updateState(CharacterState state) {
    if (state != characterState) {
      characterState = state;
      _spriteAnimationComponent.animation = _getAnimation(_spriteSheet);
    }
  }

  void _moveFromAngle(double dtUpdate) {
    final updateSpeed = currentSpeed * dtUpdate;
    if (direction == Direction.LEFT) {
      final cartPos =
          isoToCart(Vector2(characterPosition.x, characterPosition.y));
      print('cartPos[$cartPos]');
      final updatedPos =
          cartToIso(Vector2(cartPos.x - updateSpeed, cartPos.y + updateSpeed));
      characterPosition = Vector2(characterPosition.x - updateSpeed, characterPosition.y + updateSpeed);
      print('moveLeft[$characterPosition]');
    } else if (direction == Direction.RIGHT) {
      final cartPos =
          isoToCart(Vector2(characterPosition.x, characterPosition.y));
      print('cartPos[$cartPos]');
      final updatedPos =
          cartToIso(Vector2(cartPos.x + updateSpeed, cartPos.y - updateSpeed));
      characterPosition = Vector2(characterPosition.x + updateSpeed, characterPosition.y - updateSpeed);
      print('moveRight[$characterPosition]');
    }

    position = characterPosition;
  }

  SpriteAnimation _getAnimation(SpriteSheet spriteSheet) {
    late SpriteAnimation characterAnimation;

    switch (characterState) {
      case CharacterState.DANCE:
        characterAnimation = spriteSheet
            .createAnimation(row: 0, stepTime: 0.1, from: 5, to: 7)
            .reversed();
        break;

      case CharacterState.MOVE:
        if (direction == Direction.LEFT) {
          characterAnimation = spriteSheet
              .createAnimation(row: 5, stepTime: 0.1, from: 1, to: 8)
              .reversed();
        } else if (direction == Direction.RIGHT) {
          characterAnimation = spriteSheet.createAnimation(
              row: 4, stepTime: 0.1, from: 1, to: 8);
        }
        break;

      case CharacterState.IDLE:
      default:
        characterAnimation = spriteSheet
            .createAnimation(row: 3, stepTime: 0.2, from: 0, to: 2)
            .reversed();
        break;
    }

    return characterAnimation;
  }
}

enum CharacterState {
  IDLE,
  MOVE,
  DANCE,
}

enum Direction {
  LEFT,
  RIGHT,
  UP,
  DOWN,
}
