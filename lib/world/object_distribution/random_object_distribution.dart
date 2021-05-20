import 'dart:math';

import 'package:farcon/world/object_distribution/object_distribution.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flame/components.dart';

class RandomObjectDistribution extends ObjectDistribution {
  RandomObjectDistribution({
    required List<String> sprites,
    required int seedCountMax,
    required int seedCountMin,
    required int imageSize,
    required int mapSize,
    int priority = 0,
    CenterTo centerImageTo = CenterTo.CENTER_BOTTOM,
    List<Vector2> noDrawCoordinates = const [],
    Function(List<Vector2> distributionCoordinates)? callback,
  }) : super(
          sprites: sprites,
          seedCountMin: seedCountMin,
          seedCountMax: seedCountMax,
          imageSize: imageSize,
          mapSize: mapSize,
          priority: priority,
          callback: callback,
          centerImageTo: centerImageTo,
          noDrawCoordinates: noDrawCoordinates,
        );

  @override
  List<Vector2> getLocations() {
    final size = mapSize;
    int seedCount = Random().nextInt(seedCountMax);
    if (seedCount < seedCountMin) seedCount = seedCountMin;

    List<Vector2> coordinates = [];
    for (int i = 0; i < seedCount; i++) {
      final coordinate = Vector2(
        Random().nextInt(size).toDouble(),
        Random().nextInt(size).toDouble(),
      );

      if (!noDrawCoordinates.contains(coordinate)) {
        coordinates.add(coordinate);
      } else {
        seedCount++;
      }
    }

    coordinates.sort((a, b) => a.y > b.y || a.x > b.x ? 1 : 0);

    return coordinates;
  }
}
