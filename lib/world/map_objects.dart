import 'dart:math';

import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flame/components.dart';

import '../game.dart';

class MapObjects extends PositionComponent with HasGameRef<Farcon>, MapUtils {
  final List<String> sprites;
  final int seedCountMax;
  final int seedCountMin;
  final int imageSize;
  final List<Vector2> noDrawCoordinates;
  final CenterTo centerImageTo;

  MapObjects({
    required this.sprites,
    required this.seedCountMax,
    required this.seedCountMin,
    required this.imageSize,
    this.centerImageTo = CenterTo.CENTER_BOTTOM,
    this.noDrawCoordinates = const [],
  });

  @override
  Future<void> onLoad() async {
    await _loadObjects();
  }

  Future _loadObjects() async {
    int count = sprites.length;
    final coordinates = _getLocations();
    for (var coordinate in coordinates) {
      final spriteString = sprites[Random().nextInt(count)];
      final image = await gameRef.images.load(spriteString);
      final isoPosition = cartToIso(coordinate);
      final sprite = SpriteComponent.fromImage(
        image,
        position: alignCoordinateToImage(
          isoPosition,
          imageSize,
          imageSize - MapConstants.destTileSize ~/ 3,
          centerTo: centerImageTo,
        ),
      );
      await gameRef.add(sprite);
    }
  }

  List<Vector2> _getLocations() {
    final size = MapConstants.mapSize;
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
