import 'dart:math';

import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flame/components.dart';

import '../../game.dart';

abstract class ObjectDistribution extends PositionComponent with HasGameRef<Farcon>, MapUtils {
  final List<String> sprites;
  final int seedCountMax;
  final int seedCountMin;
  final int imageSize;
  final int mapSize;
  final List<Vector2> noDrawCoordinates;
  final CenterTo centerImageTo;

  ObjectDistribution({
    required this.sprites,
    required this.seedCountMax,
    required this.seedCountMin,
    required this.imageSize,
    required this.mapSize,
    this.centerImageTo = CenterTo.CENTER_BOTTOM,
    this.noDrawCoordinates = const [],
  });

  @override
  Future<void> onLoad() async {
    await loadObjects();
  }

  Future loadObjects() async {
    int count = sprites.length;
    final coordinates = getLocations();
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

  List<Vector2> getLocations();
}
