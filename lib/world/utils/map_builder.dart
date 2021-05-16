import 'dart:math';

import 'package:farcon/world/models/dam.dart';
import 'package:flame/components.dart';

const cubeSize = 120;
const waterBorderSize = 10;
const waterBorderRandomSize = 5;
const largesDamSize = 4;
const damCountMax = 4;

const top = 1;
const left = 2;
const right = 3;
const bottom = 4;

const grass = 0;
const stone = 1;
const sand = 2;
const water = 3;

mixin MapBuilder {
  List<List<int>> buildMap() {
    final waterEdges = _generateWaterEdges();
    final dams = _generateDams();

    List<List<int>> matrix = [];

    for (int row = 0; row < cubeSize; row++) {
      List<int> rowTiles = [];
      for (int column = 0; column < cubeSize; column++) {
        if (_drawEdges(column, row, rowTiles, waterEdges)) continue;
        if (_drawDams(dams, column, row, rowTiles)) continue;

        rowTiles.add(grass);
      }
      matrix.add(rowTiles);
    }

    return matrix;
  }

  Map<int, List<int>> _generateWaterEdges() {
    final Map<int, List<int>> waterEdges = {};
    waterEdges[top] = _generateWaterBorderNumbers();
    waterEdges[bottom] = _generateWaterBorderNumbers();
    waterEdges[left] = _generateWaterBorderNumbers();
    waterEdges[right] = _generateWaterBorderNumbers();
    return waterEdges;
  }

  List<int> _generateWaterBorderNumbers() {
    List<int> numbers = [];
    int previousNumber = -1;
    for (int point = 0; point < 100; point++) {
      final randomNumber =
          Random().nextInt(waterBorderRandomSize) + waterBorderSize;
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
    if (seedNumbers.length < cubeSize) {
      seedNumbers.add(s);
    }
  }

  void _buildEdge(List<int>? numbers, int row, int column, List<int> tiles,
      bool startEdge) {
    final input = numbers ?? [];
    int number = startEdge ? input[row] : cubeSize - input[column];
    bool value = startEdge ? column < number : row > number;
    if (value) {
      tiles.add(water);
    } else {
      tiles.add(grass);
    }
  }

  bool _drawEdges(
      int column, int row, List<int> rowTiles, Map<int, List<int>> waterEdges) {
    if (column < waterBorderSize ||
        column > cubeSize - waterBorderSize ||
        row < waterBorderSize ||
        row > cubeSize - waterBorderSize) {
      rowTiles.add(water);
      return true;
    } else {
      final threshold = waterBorderRandomSize + waterBorderSize;
      final rightThreshold = cubeSize - threshold;
      final bottomThreshold = cubeSize - threshold;
      if (row < threshold) {
        _buildEdge(waterEdges[top], column, row, rowTiles, true);
        return true;
      } else if (column < threshold) {
        _buildEdge(waterEdges[left], row, column, rowTiles, true);
        return true;
      } else if (row > bottomThreshold) {
        _buildEdge(waterEdges[bottom], row, column, rowTiles, false);
        return true;
      } else if (column > rightThreshold) {
        _buildEdge(waterEdges[right], column, row, rowTiles, false);
        return true;
      }
    }

    return false;
  }

  List<Dam> _generateDams() {
    List<Dam> dams = [];
    final damCount = Random().nextInt(damCountMax) + 1;
    final waterBorder = waterBorderSize + waterBorderRandomSize;
    for (int i = 0; i < damCount; i++) {
      final Vector2 damCenter = Vector2(
        (Random().nextInt(cubeSize - waterBorder) + waterBorder).toDouble(),
        (Random().nextInt(cubeSize - waterBorder) + waterBorder).toDouble(),
      );
      final radius = Random().nextInt(largesDamSize) + 3;
      dams.add(Dam(damCenter, radius));
    }
    return dams;
  }

  bool _drawDams(List<Dam> dams, int column, int row, List<int> rowTiles) {
    bool hasDam = false;
    for (Dam dam in dams) {
      final damPoint =
          ((column - dam.coordinates.x) * (column - dam.coordinates.x) +
                  (row - dam.coordinates.y) * (row - dam.coordinates.y)) <=
              dam.radius * dam.radius;
      if (damPoint) {
        rowTiles.add(water);
        hasDam = true;
      }
    }
    return hasDam;
  }
}
