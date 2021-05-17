
import 'dart:math';

import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/constants/strings.dart';
import 'package:farcon/game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import 'models/dam.dart';

class DefaultMap extends PositionComponent with HasGameRef<Farcon> {

  @override
  Future<void> onLoad() async {
    await _loadMap();
  }

  Future _loadMap() async {
    final image = await gameRef.images.load(Strings.mapTileSprite);
    final tileset = SpriteSheet(
      image: image,
      srcSize: Vector2.all(MapConstants.srcTileSize),
    );

    gameRef.add(
      IsometricTileMapComponent(
        tileset,
        buildMap(),
        destTileSize: Vector2.all(MapConstants.destTileSize),
      )
        ..x = x
        ..y = y,
    );
  }

  List<List<int>> buildMap() {
    final waterEdges = _generateWaterEdges();
    final dams = _generateDams();

    List<List<int>> matrix = [];

    for (int row = 0; row < MapConstants.cubeSize; row++) {
      List<int> rowTiles = [];
      for (int column = 0; column < MapConstants.cubeSize; column++) {
        if (_drawEdges(column, row, rowTiles, waterEdges)) continue;
        if (_drawDams(dams, column, row, rowTiles)) continue;

        rowTiles.add(MapConstants.grass);
      }
      matrix.add(rowTiles);
    }

    return matrix;
  }

  Map<int, List<int>> _generateWaterEdges() {
    final Map<int, List<int>> waterEdges = {};
    waterEdges[MapConstants.top] = _generateWaterBorderNumbers();
    waterEdges[MapConstants.bottom] = _generateWaterBorderNumbers();
    waterEdges[MapConstants.left] = _generateWaterBorderNumbers();
    waterEdges[MapConstants.right] = _generateWaterBorderNumbers();
    return waterEdges;
  }

  List<int> _generateWaterBorderNumbers() {
    List<int> numbers = [];
    int previousNumber = -1;
    for (int point = 0; point < 100; point++) {
      final randomNumber =
          Random().nextInt(MapConstants.waterBorderRandomSize) +
              MapConstants.waterBorderSize;
      if (previousNumber == -1) {
        previousNumber = randomNumber;
      } else {
        _addNumber(numbers, previousNumber);
        _addNumber(numbers, previousNumber);
        if (previousNumber > randomNumber) {
          for (int downNumber = previousNumber;
          downNumber > randomNumber;
          downNumber--) {
            _addNumber(numbers, downNumber);
          }
        } else if (previousNumber < randomNumber) {
          for (int upNumber = previousNumber;
          upNumber < randomNumber;
          upNumber++) {
            _addNumber(numbers, upNumber);
          }
        }
        previousNumber = randomNumber;
      }
    }

    return numbers;
  }

  void _addNumber(List<int> seedNumbers, int s) {
    if (seedNumbers.length < MapConstants.cubeSize) {
      seedNumbers.add(s);
    }
  }

  void _buildEdge(List<int>? numbers, int row, int column, List<int> tiles,
      bool startEdge) {
    final input = numbers ?? [];
    int number = startEdge ? input[row] : MapConstants.cubeSize - input[column];
    bool value = startEdge ? column < number : row > number;
    if (value) {
      tiles.add(MapConstants.water);
    } else {
      tiles.add(MapConstants.grass);
    }
  }

  bool _drawEdges(
      int column, int row, List<int> rowTiles, Map<int, List<int>> waterEdges) {
    if (column < MapConstants.waterBorderSize ||
        column > MapConstants.cubeSize - MapConstants.waterBorderSize ||
        row < MapConstants.waterBorderSize ||
        row > MapConstants.cubeSize - MapConstants.waterBorderSize) {
      rowTiles.add(MapConstants.water);
      return true;
    } else {
      final threshold =
          MapConstants.waterBorderRandomSize + MapConstants.waterBorderSize;
      final rightThreshold = MapConstants.cubeSize - threshold;
      final bottomThreshold = MapConstants.cubeSize - threshold;
      if (row < threshold) {
        _buildEdge(waterEdges[MapConstants.top], column, row, rowTiles, true);
        return true;
      } else if (column < threshold) {
        _buildEdge(waterEdges[MapConstants.left], row, column, rowTiles, true);
        return true;
      } else if (row > bottomThreshold) {
        _buildEdge(
            waterEdges[MapConstants.bottom], row, column, rowTiles, false);
        return true;
      } else if (column > rightThreshold) {
        _buildEdge(
            waterEdges[MapConstants.right], column, row, rowTiles, false);
        return true;
      }
    }

    return false;
  }

  List<Dam> _generateDams() {
    List<Dam> dams = [];
    final damCount = Random().nextInt(MapConstants.damCountMax) + 1;
    final waterBorder =
        MapConstants.waterBorderSize + MapConstants.waterBorderRandomSize;
    for (int i = 0; i < damCount; i++) {
      final Vector2 damCenter = Vector2(
        (Random().nextInt(MapConstants.cubeSize - waterBorder) + waterBorder)
            .toDouble(),
        (Random().nextInt(MapConstants.cubeSize - waterBorder) + waterBorder)
            .toDouble(),
      );
      final radius = Random().nextInt(MapConstants.largesDamSize) + 3;
      dams.add(Dam(damCenter, radius));
    }
    return dams;
  }

  /*
   * Equation for getting dam coordinates for radius and size.
   */
  bool _drawDams(List<Dam> dams, int column, int row, List<int> rowTiles) {
    bool hasDam = false;
    for (Dam dam in dams) {
      final xCalculation =
          (column - dam.coordinates.x) * (column - dam.coordinates.x);
      final yCalculation =
          (row - dam.coordinates.y) * (row - dam.coordinates.y);
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