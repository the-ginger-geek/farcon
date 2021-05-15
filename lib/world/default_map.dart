
import 'package:farcon/game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

import 'utils/map_builder.dart';

const x = 500.0;
const y = 250.0;
final topLeft = Vector2(x, y);

const scale = 2.0;
const srcTileSize = 32.0;
const destTileSize = scale * srcTileSize;
const halfSize = true;
const tileHeight = scale * (halfSize ? 8.0 : 16.0);

final originColor = Paint()..color = const Color(0xFFFF00FF);
final originColor2 = Paint()..color = const Color(0xFFAA55FF);

class DefaultMap extends PositionComponent with MapBuilder, HasGameRef<Farcon> {
  final String tileSprite = 'tiles.png';
  static const double SPEED = 500;

  int _horizontalDirection = 0;
  int _verticalDirection = 0;

  void moveRight() { _horizontalDirection = 1; }
  void moveLeft() { _horizontalDirection = -1; }
  void moveUp() { _verticalDirection = -1; }
  void moveDown() { _verticalDirection = 1; }
  void stopMoving() {
    _horizontalDirection = 0;
    _verticalDirection = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Calculates how much we are going to move on this iteration
    final stepHorizontal = _horizontalDirection * SPEED * dt;
    final stepVertical = _verticalDirection * SPEED * dt;
    gameRef.camera.cameraSpeed = SPEED;
      final camPos = gameRef.camera.position;
    final x = camPos.x += stepHorizontal;
    final y = camPos.y += stepVertical;
    gameRef.camera.moveTo(Vector2(x, y));
  }

  @override
  Future<void> onLoad() async {
    await _loadMap();
  }

  Future _loadMap() async {
    final image = await gameRef.images.load(tileSprite);
    final tileset = SpriteSheet(
      image: image,
      srcSize: Vector2.all(srcTileSize),
    );

    gameRef.add(
      IsometricTileMapComponent(
        tileset,
        buildMap(),
        destTileSize: Vector2.all(srcTileSize),
      )
        ..x = x
        ..y = y,
    );
  }
}