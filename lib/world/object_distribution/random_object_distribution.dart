import 'dart:math';

import 'package:farcon/world/object_distribution/object_distribution.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flame/components.dart';

class RandomObjectDistribution extends ObjectDistribution {
  RandomObjectDistribution({
    required List<String> sprites,
    required Vector2 leftTop,
    required int seedCountMax,
    required int seedCountMin,
    required int imageSize,
    required int blockSize,
    int priority = 0,
    CenterTo centerImageTo = CenterTo.CENTER_BOTTOM,
    List<Vector2> noDrawCoordinates = const [],
    Function(List<Vector2> distributionCoordinates)? callback,
  }) : super(
          sprites: sprites,
          leftTop: leftTop,
          seedCountMin: seedCountMin,
          seedCountMax: seedCountMax,
          imageSize: imageSize,
          blockSize: blockSize,
          callback: callback,
          centerImageTo: centerImageTo,
          noDrawCoordinates: noDrawCoordinates,
        );

  @override
  List<Vector2> getLocations() {
    int seedCount = Random().nextInt(seedCountMax);
    if (seedCount < seedCountMin) seedCount = seedCountMin;

    List<Vector2> coordinates = [];
    for (int i = 0; i < seedCount; i++) {
      Vector2 coordinate = _getRandomCoordinate();
      if (!noDrawCoordinates.contains(coordinate) &&
          coordinate.x > leftTop.x &&
          coordinate.x < leftTop.x + blockSize &&
          coordinate.y > leftTop.y &&
          coordinate.y < leftTop.y + blockSize) {
        coordinates.add(coordinate);
      } else {
        seedCount++;
      }
    }

    coordinates.sort((a, b) => a.y > b.y || a.x > b.x ? 1 : 0);

    return coordinates;
  }

  Vector2 _getRandomCoordinate() {
    final coordinate = Vector2(
      Random().nextInt(leftTop.x.toInt() + blockSize).toDouble(),
      Random().nextInt(leftTop.y.toInt() + blockSize).toDouble(),
    );
    return coordinate;
  }
}
