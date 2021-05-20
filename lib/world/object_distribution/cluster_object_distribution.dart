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
    required List<String> sprites,
    required int clusterCountMax,
    required int clusterCountMin,
    required int imageSize,
    required int mapSize,
    int priority = 0,
    CenterTo centerImageTo = CenterTo.CENTER_BOTTOM,
    List<Vector2> noDrawCoordinates = const [],
    Function(List<Vector2> distributionCoordinates)? callback,
  }) : super(
          sprites: sprites,
          seedCountMin: clusterCountMin,
          seedCountMax: clusterCountMax,
          imageSize: imageSize,
          mapSize: mapSize,
          priority: priority,
          callback: callback,
          centerImageTo: centerImageTo,
          noDrawCoordinates: noDrawCoordinates,
        );

  @override
  List<Vector2> getLocations() {
    List<Vector2> coordinates = [];
    final centerCoordinates = _generateClusterCenterPoints();
    for (int x = 0; x < mapSize; x++) {
      for (int y = 0; y < mapSize; y++) {
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
      final Vector2 center = Vector2(
        (Random().nextInt(mapSize)).toDouble(),
        (Random().nextInt(mapSize)).toDouble(),
      );
      int radius = Random().nextInt(radiusSizeMin);
      if (radius < radiusSizeMin) radius = radiusSizeMin;

      if (center.x - radius > 0 &&
          center.x + radius < mapSize &&
          center.y - radius > 0 &&
          center.y + radius < mapSize) {
        _centerCoordinates.add(Circle(center, radius));
      } else {
        count++;
      }
    }

    print(_centerCoordinates);

    return _centerCoordinates;
  }
}
