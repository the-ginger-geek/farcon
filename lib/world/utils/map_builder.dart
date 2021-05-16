import 'dart:math';

const cubeSize = 100;
const waterBorderSize = 10;
const waterBorderRandomSize = 5;
const grass = 0;
const stone = 1;
const sand = 2;
const water = 3;

mixin MapBuilder {

  List<List<int>> buildMap() {
    final topEdge = _generateWaterBorderNumbers();
    final bottomEdge = _generateWaterBorderNumbers();
    final leftEdge = _generateWaterBorderNumbers();
    final rightEdge = _generateWaterBorderNumbers();

    List<List<int>> matrix = [];

    for (int row = 0; row < cubeSize; row++) {
      List<int> rowTiles = [];
      for (int column = 0; column < cubeSize; column++) {
        if (column < waterBorderSize ||
            column > cubeSize - waterBorderSize ||
            row < waterBorderSize ||
            row > cubeSize - waterBorderSize) {
          rowTiles.add(water);
        } else {
          final threshold = waterBorderRandomSize + waterBorderSize;
          final rightThreshold = cubeSize - threshold;
          final bottomThreshold = cubeSize - threshold;

          if (row < threshold) {
            _buildEdge(topEdge, column, row, rowTiles, true);
          } else if (column < threshold) {
            _buildEdge(leftEdge, row, column, rowTiles, true);
          } else if (row > bottomThreshold) {
            _buildEdge(bottomEdge, row, column, rowTiles, false);
          } else if (column > rightThreshold) {
            _buildEdge(rightEdge, column, row, rowTiles, false);
          } else {
            rowTiles.add(grass);
          }
        }
      }
      matrix.add(rowTiles);
    }

    return matrix;
  }

  List<int> _generateWaterBorderNumbers() {
    List<int> seedNumbers = [];
    int previousNumber = -1;
    for (int p = 0; p < 100; p++) {
      final i = Random().nextInt(waterBorderRandomSize) + waterBorderSize;
      if (previousNumber == -1) {
        previousNumber = i;
      } else {
        _addSeedNumber(seedNumbers, previousNumber);
        _addSeedNumber(seedNumbers, previousNumber);
        if (previousNumber > i) {
          for (int s = previousNumber; s > i; s--) {
            _addSeedNumber(seedNumbers, s);
          }
        } else if (previousNumber < i) {
          for (int s = previousNumber; s < i; s++) {
            _addSeedNumber(seedNumbers, s);
          }
        }
        previousNumber = i;
      }
    }

    return seedNumbers;
  }

  void _addSeedNumber(List<int> seedNumbers, int s) {
    if (seedNumbers.length < cubeSize) {
      seedNumbers.add(s);
    }
  }

  void _buildEdge(List<int> numbers, int row, int column, List<int> tiles, bool startEdge) {
    int number = startEdge ? numbers[row] : cubeSize - numbers[column];
    bool value = startEdge ? column < number : row > number;
    if (value) {
      tiles.add(water);
    } else {
      tiles.add(grass);
    }
  }
}

