import 'package:farcon/game/controls/direction.dart';
import 'package:farcon/game/game.dart';
import 'package:farcon/game/world/utils/map_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import 'character_state.dart';

class Character extends PositionComponent
    with HasGameRef<Farcon>, MapUtils
    implements JoystickListener {
  static const speed = 64.0;

  final String characterPath;
  final double characterWidth;
  final double characterHeight;
  late SpriteSheet _spriteSheet;
  late SpriteAnimationComponent _spriteAnimationComponent;

  Vector2 characterPosition = Vector2(0, 0);
  double currentSpeed = 0;

  CharacterState characterState = CharacterState.IDLE;
  Direction direction = Direction.RIGHT;

  Character({
    required this.characterPath,
    required this.characterWidth,
    required this.characterHeight,
  });

  @override
  Future<void> onLoad() async {
    _spriteSheet = SpriteSheet(
      image: await gameRef.images.load(characterPath),
      srcSize: Vector2(characterWidth, characterHeight),
    );

    _spriteAnimationComponent = SpriteAnimationComponent(
      animation: _getAnimation(_spriteSheet),
      size: Vector2(48.0, 64.0),
    );

    addChild(_spriteAnimationComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (characterState == CharacterState.MOVE) {
      final updateSpeed = currentSpeed * dt;
      if (direction == Direction.LEFT) {
        characterPosition =
            Vector2(characterPosition.x - updateSpeed, characterPosition.y);
      } else if (direction == Direction.RIGHT) {
        characterPosition =
            Vector2(characterPosition.x + updateSpeed, characterPosition.y);
      } else if (direction == Direction.UP) {
        characterPosition =
            Vector2(characterPosition.x, characterPosition.y - updateSpeed);
      } else if (direction == Direction.DOWN) {
        characterPosition =
            Vector2(characterPosition.x, characterPosition.y + updateSpeed);
      }

      if (characterPosition != position) {
        position = characterPosition;
      }
    }
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.down) {
      if (event.id == 1) {
        updateState(CharacterState.DANCE);
      }
    }
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    bool move = event.directional != JoystickMoveDirectional.idle;
    if (move) {
      final eAngle = event.angle;
      currentSpeed = speed * event.intensity;
      final previousDirection = direction;
      if (eAngle < 0 && eAngle > -1 || eAngle > 0 && eAngle < 1) {
        direction = Direction.RIGHT;
      } else if (eAngle < 3 && eAngle > 2 || eAngle > -3 && eAngle < -2) {
        direction = Direction.LEFT;
      } else if (eAngle < 2 && eAngle > 1) {
        direction = Direction.DOWN;
      } else if (eAngle > -2 && eAngle < -1) {
        direction = Direction.UP;
      }
      updateState(CharacterState.MOVE,
          directionChanged: previousDirection != direction);
    } else {
      updateState(CharacterState.IDLE);
    }
  }

  void keyMove(String key) {
    switch (key.toUpperCase()) {
      case 'A':
        _moveInDirection(Direction.LEFT);
        break;
      case 'D':
        _moveInDirection(Direction.RIGHT);
        break;
      case 'W':
        _moveInDirection(Direction.UP);
        break;
      case 'S':
        _moveInDirection(Direction.DOWN);
        break;
      default:
        updateState(CharacterState.IDLE);
    }
  }

  void _moveInDirection(Direction newDirection) {
    final previousDirection = direction;
    currentSpeed = speed;
    direction = newDirection;
    updateState(CharacterState.MOVE,
        directionChanged: previousDirection != direction);
  }

  void updateState(CharacterState state, {bool directionChanged = false}) {
    if (state != characterState || directionChanged) {
      characterState = state;
      _spriteAnimationComponent.animation = _getAnimation(_spriteSheet);
    }

    final cart = isoToCart(Vector2(characterPosition.x + (characterWidth/2), characterPosition.y + (characterHeight/3)));
    print('cart: $cart');
    int priority = getPriorityFromCoordinate(cart);
    gameRef.changePriority(this, priority);
  }

  SpriteAnimation _getAnimation(SpriteSheet spriteSheet) {
    late SpriteAnimation characterAnimation;
    switch (characterState) {
      case CharacterState.DANCE:
        characterAnimation = _danceAnimation(spriteSheet);
        break;
      case CharacterState.MOVE:
        characterAnimation = _moveAnimation(spriteSheet);
        break;
      case CharacterState.IDLE:
      default:
        characterAnimation = _idleAnimation(spriteSheet);
        break;
    }
    return characterAnimation;
  }

  SpriteAnimation _danceAnimation(SpriteSheet spriteSheet) {
    SpriteAnimation characterAnimation = spriteSheet
        .createAnimation(row: 0, stepTime: 0.1, from: 5, to: 7)
        .reversed();
    return characterAnimation;
  }

  SpriteAnimation _idleAnimation(SpriteSheet spriteSheet) {
    SpriteAnimation characterAnimation = spriteSheet
        .createAnimation(row: 0, stepTime: 0.2, from: 0, to: 1)
        .reversed();
    return characterAnimation;
  }

  SpriteAnimation _moveAnimation(SpriteSheet spriteSheet) {
    late SpriteAnimation characterAnimation;
    if (direction == Direction.LEFT) {
      characterAnimation = spriteSheet
          .createAnimation(row: 5, stepTime: 0.1, from: 1, to: 8)
          .reversed();
    } else if (direction == Direction.RIGHT ||
        direction == Direction.DOWN) {
      characterAnimation = spriteSheet.createAnimation(
          row: 4, stepTime: 0.1, from: 1, to: 8);
    } else if (direction == Direction.UP) {
      characterAnimation = spriteSheet
          .createAnimation(row: 0, stepTime: 0.13, from: 5, to: 7)
          .reversed();
    } else {
      characterAnimation = _idleAnimation(spriteSheet);
    }

    return characterAnimation;
  }
}
