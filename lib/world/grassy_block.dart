import 'dart:math';
import 'dart:ui';

import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/constants/asset_paths.dart';
import 'package:farcon/game.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import 'models/circle.dart';

class GrassyBlock extends PositionComponent with HasGameRef<Farcon>, MapUtils {
  late IsometricTileMapComponent _map;
  final int mapSize;
  final Vector2 leftTop;

  List<Vector2> waterCoordinates = [];
  final Function(List<Vector2> noDrawCoordinates)? loadComplete;

  GrassyBlock({
    required this.mapSize,
    required this.leftTop,
    this.loadComplete,
  });

  @override
  Future<void> onLoad() async {
    await _loadMap();
    loadComplete?.call(waterCoordinates);
  }

  Block getBlock(Vector2 screenPosition) => _map.getBlock(screenPosition);

  bool containsBlock(Block block) => _map.containsBlock(block);

  Vector2 getBlockPosition(Block block) => _map.getBlockPosition(block);

  Future _loadMap() async {
    final image = await gameRef.images.load(AssetPaths.mapTileSprite);
    final tileset = SpriteSheet(
      image: image,
      srcSize: Vector2.all(MapConstants.srcTileSize),
    );

    gameRef.add(_map = IsometricTileMapComponent(
      tileset,
      buildMap(),
      position: cartToIso(leftTop),
      destTileSize: Vector2.all(MapConstants.destTileSize),
    ));
  }

  List<List<int>> buildMap() {
    final dams = _generateDams();

    List<List<int>> matrix = [];

    for (double row = leftTop.y; row < leftTop.y + mapSize; row++) {
      List<int> rowTiles = [];
      for (double column = leftTop.x; column < leftTop.x + mapSize; column++) {
        if (_drawDams(dams, column, row, rowTiles)) continue;

        rowTiles.add(MapConstants.grass);
      }
      matrix.add(rowTiles);
    }

    return matrix;
  }

  List<Circle> _generateDams() {
    List<Circle> dams = [];
    int damCount = Random().nextInt(MapConstants.damCountMax);

    if (damCount < MapConstants.damCountMax)
      damCount = MapConstants.damCountMin;

    for (int i = 0; i < damCount; i++) {
      final Vector2 damCenter = Vector2(
        (Random().nextInt(leftTop.x.toInt() + mapSize)).toDouble(),
        (Random().nextInt(leftTop.y.toInt() + mapSize)).toDouble(),
      );
      final radius = Random().nextInt(MapConstants.largestDamSize) + 3;
      dams.add(Circle(damCenter, radius));
    }
    return dams;
  }

  /*
   * Equation for getting dam coordinates for radius and size.
   */
  bool _drawDams(List<Circle> dams, double x, double y, List<int> rowTiles) {
    bool hasDam = false;
    for (Circle dam in dams) {
      final xCoordinate = (x - dam.coords.x) * (x - dam.coords.x);
      final yCoordinate = (y - dam.coords.y) * (y - dam.coords.y);
      final damSize = dam.radius * dam.radius;
      final damPoint = (xCoordinate + yCoordinate) <= damSize;
      if (damPoint) {
        rowTiles.add(MapConstants.water);
        waterCoordinates.add(Vector2(x, y));
        hasDam = true;
      }
    }
    return hasDam;
  }
}