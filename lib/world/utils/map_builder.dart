import 'dart:math';

mixin MapBuilder {
  final cubeSize = 60;
  final waterBorderSize = 4;
  final waterBorderRandomSize = 5;
  final grass = 0;
  final stone = 1;
  final sand = 2;
  final water = 3;

  List<List<int>> buildMap() {
    final topEdge = _generateSeedNumbers();
    final bottomEdge = _generateSeedNumbers();
    final leftEdge = _generateSeedNumbers();
    final rightEdge = _generateSeedNumbers();

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
            _buildSmallEdge(topEdge, column, row, rowTiles);
          } else if (column < threshold) {
            _buildSmallEdge(leftEdge, row, column, rowTiles);
          } else if (row > bottomThreshold) {
            _buildLargeEdge(bottomEdge, column, row, rowTiles);
          } else if (column > rightThreshold) {
            _buildLargeEdge(rightEdge, row, column, rowTiles);
          } else {
            rowTiles.add(grass);
          }
        }
      }
      matrix.add(rowTiles);
    }

    return matrix;
  }

  List<int> _generateSeedNumbers() {
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

  void _buildLargeEdge(List<int> bottomEdge, int column, int row, List<int> rowTiles) {
    int rowNumber = cubeSize - bottomEdge[column];
    if (row > rowNumber) {
      rowTiles.add(water);
    } else {
      rowTiles.add(grass);
    }
  }

  void _buildSmallEdge(List<int> leftEdge, int row, int column, List<int> rowTiles) {
    int columnNumber = leftEdge[row];
    if (column < columnNumber) {
      rowTiles.add(water);
    } else {
      rowTiles.add(grass);
    }
  }
}

