import 'dart:math';

import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/constants/strings.dart';
import 'package:farcon/game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import 'models/dam.dart';

class DefaultMap extends PositionComponent with HasGameRef<Farcon> {
  late IsometricTileMapComponent _map;

  @override
  Future<void> onLoad() async {
    await _loadMap();
  }

  Block getBlock(Vector2 screenPosition) => _map.getBlock(screenPosition);

  bool containsBlock(Block block) => _map.containsBlock(block);

  Vector2 getBlockPosition(Block block) => _map.getBlockPosition(block);

  Future _loadMap() async {
    final image = await gameRef.images.load(Strings.mapTileSprite);
    final tileset = SpriteSheet(
      image: image,
      srcSize: Vector2.all(MapConstants.srcTileSize),
    );

    gameRef.add(_map = IsometricTileMapComponent(
      tileset,
      buildMap(),
      destTileSize: Vector2.all(MapConstants.destTileSize),
      position: Vector2(MapConstants.xZero, MapConstants.yZero),
    ));
  }

  List<List<int>> buildMap() {
    final dams = _generateDams();

    List<List<int>> matrix = [];

    for (int row = 0; row < MapConstants.cubeSize; row++) {
      List<int> rowTiles = [];
      for (int column = 0; column < MapConstants.cubeSize; column++) {
        if (_drawDams(dams, column, row, rowTiles)) continue;

        rowTiles.add(MapConstants.grass);
      }
      matrix.add(rowTiles);
    }

    return matrix;
  }

  List<Dam> _generateDams() {
    List<Dam> dams = [];
    final damCount = Random().nextInt(MapConstants.damCountMax);
    for (int i = 0; i < damCount; i++) {
      final Vector2 damCenter = Vector2(
        (Random().nextInt(MapConstants.cubeSize)).toDouble(),
        (Random().nextInt(MapConstants.cubeSize)).toDouble(),
      );
      final radius = Random().nextInt(MapConstants.largesDamSize) + 3;
      dams.add(Dam(damCenter, radius));
    }
    return dams;
  }

  /*
   * Equation for getting dam coordinates for radius and size.
   */
  bool _drawDams(List<Dam> dams, int x, int y, List<int> rowTiles) {
    bool hasDam = false;
    for (Dam dam in dams) {
      final xCalculation = (x - dam.coords.x) * (x - dam.coords.x);
      final yCalculation = (y - dam.coords.y) * (y - dam.coords.y);
      final damSize = dam.radius * dam.radius;
      final damPoint = (xCalculation + yCalculation) <= damSize;
      if (damPoint) {
        rowTiles.add(MapConstants.water);
        hasDam = true;
      }
    }
    return hasDam;
  }
}
