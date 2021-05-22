import 'dart:math';

import 'package:farcon/world/models/circle.dart';
import 'package:farcon/world/object_distribution/object_distribution.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flame/components.dart';

class ClusterObjectDistribution extends ObjectDistribution {
  final int radiusSizeMin;
  final int radiusSizeMax;

  ClusterObjectDistribution({
    required this.radiusSizeMin,
    required this.radiusSizeMax,
    required Vector2 leftTop,
    required List<String> sprites,
    required int clusterCountMax,
    required int clusterCountMin,
    required int imageSize,
    required int blockSize,
    CenterTo centerImageTo = CenterTo.CENTER_BOTTOM,
    List<Vector2> noDrawCoordinates = const [],
    Function(List<Vector2> distributionCoordinates)? callback,
  }) : super(
          sprites: sprites,
          leftTop: leftTop,
          seedCountMin: clusterCountMin,
          seedCountMax: clusterCountMax,
          imageSize: imageSize,
          blockSize: blockSize,
          callback: callback,
          centerImageTo: centerImageTo,
          noDrawCoordinates: noDrawCoordinates,
        );

  @override
  List<Vector2> getLocations() {
    List<Vector2> coordinates = [];
    final centerCoordinates = _generateClusterCenterPoints();
    for (int x = leftTop.x.toInt(); x < leftTop.x + blockSize; x++) {
      for (int y = leftTop.y.toInt(); y < leftTop.y + blockSize; y++) {
        if (_addCoordinate(centerCoordinates, x, y, coordinates)) continue;
      }
    }

    return coordinates;
  }

  bool _addCoordinate(
      List<Circle> centerCoordinates, int x, int y, List<Vector2> coordinates) {
    bool hasObject = false;
    for (Circle circle in centerCoordinates) {
      final xCoordinate = (x - circle.coords.x) * (x - circle.coords.x);
      final yCoordinate = (y - circle.coords.y) * (y - circle.coords.y);
      final circleSize = circle.radius * circle.radius;
      final validCoordinate = (xCoordinate + yCoordinate) <= circleSize;
      final coordinate = Vector2(x.toDouble(), y.toDouble());
      if (validCoordinate && !noDrawCoordinates.contains(coordinate)) {
        coordinates.add(coordinate);
        hasObject = true;
      }
    }

    return hasObject;
  }

  List<Circle> _generateClusterCenterPoints() {
    List<Circle> _centerCoordinates = [];
    int count = Random().nextInt(seedCountMax);

    if (count < seedCountMax) count = seedCountMin;

    for (int i = 0; i < count; i++) {
      Vector2 center = _getRandomCoordinate();
      int radius = Random().nextInt(radiusSizeMin);
      if (radius < radiusSizeMin) radius = radiusSizeMin;

      if (center.x - radius > leftTop.x &&
          center.x + radius < leftTop.x + blockSize &&
          center.y - radius > leftTop.y &&
          center.y + radius < leftTop.y + blockSize) {
        _centerCoordinates.add(Circle(center, radius));
      } else {
        count++;
      }
    }

    return _centerCoordinates;
  }

  Vector2 _getRandomCoordinate() {
    final Vector2 center = Vector2(
      (Random().nextInt(leftTop.x.toInt() + blockSize)).toDouble(),
      (Random().nextInt(leftTop.y.toInt() + blockSize)).toDouble(),
    );


    return center;
  }
}
