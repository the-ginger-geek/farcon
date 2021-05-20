import 'dart:math';
import 'dart:ui';

import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/constants/strings.dart';
import 'package:farcon/game.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import 'models/circle.dart';

final originColor = Paint()..color = const Color(0xFFf5bc42);
final originColor2 = Paint()..color = const Color(0xFFf54260);
class DefaultMap extends PositionComponent with HasGameRef<Farcon>, MapUtils {
  late IsometricTileMapComponent _map;
  List<Vector2> waterCoordinates = [];
  final Function(List<Vector2> noDrawCoordinates)? loadComplete;

  DefaultMap({this.loadComplete});

  @override
  Future<void> onLoad() async {
    await _loadMap();
    loadComplete?.call(waterCoordinates);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.renderPoint(Vector2(0, 0), size: 5, paint: originColor);
    canvas.renderPoint(
      Vector2(x, y - MapConstants.tileHeight),
      size: 5,
      paint: originColor2,
    );
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
    ));
  }

  List<List<int>> buildMap() {
    final dams = _generateDams();

    List<List<int>> matrix = [];

    for (int row = 0; row < MapConstants.mapSize; row++) {
      List<int> rowTiles = [];
      for (int column = 0; column < MapConstants.mapSize; column++) {
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

    if (damCount < MapConstants.damCountMax) damCount = MapConstants.damCountMin;

    for (int i = 0; i < damCount; i++) {
      final Vector2 damCenter = Vector2(
        (Random().nextInt(MapConstants.mapSize)).toDouble(),
        (Random().nextInt(MapConstants.mapSize)).toDouble(),
      );
      final radius = Random().nextInt(MapConstants.largestDamSize) + 3;
      dams.add(Circle(damCenter, radius));
    }
    return dams;
  }

  /*
   * Equation for getting dam coordinates for radius and size.
   */
  bool _drawDams(List<Circle> dams, int x, int y, List<int> rowTiles) {
    bool hasDam = false;
    for (Circle dam in dams) {
      final xCoordinate = (x - dam.coords.x) * (x - dam.coords.x);
      final yCoordinate = (y - dam.coords.y) * (y - dam.coords.y);
      final damSize = dam.radius * dam.radius;
      final damPoint = (xCoordinate + yCoordinate) <= damSize;
      if (damPoint) {
        rowTiles.add(MapConstants.water);
        waterCoordinates.add(Vector2(x.toDouble(), y.toDouble()));
        hasDam = true;
      }
    }
    return hasDam;
  }
}
