import 'dart:math';

import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flame/components.dart';

import '../../game.dart';

abstract class ObjectDistribution extends PositionComponent
    with HasGameRef<Farcon>, MapUtils {
  @override
  final int priority;
  final Vector2 leftTop;
  final List<String> sprites;
  final int seedCountMax;
  final int seedCountMin;
  final int imageSize;
  final int blockSIze;
  final CenterTo centerImageTo;
  final List<Vector2> noDrawCoordinates;
  final List<Vector2> distributionCoordinates = [];
  final Function(List<Vector2> distributionCoordinates)? callback;

  ObjectDistribution({
    required this.sprites,
    required this.leftTop,
    required this.seedCountMax,
    required this.seedCountMin,
    required this.imageSize,
    required this.blockSIze,
    required this.priority,
    this.callback,
    this.centerImageTo = CenterTo.CENTER_BOTTOM,
    this.noDrawCoordinates = const [],
  });

  @override
  Future<void> onLoad() async {
    await loadObjects();
    callback?.call(distributionCoordinates);
  }

  Future loadObjects() async {
    int count = sprites.length;
    final coordinates = getLocations();
    for (var coordinate in coordinates) {
      distributionCoordinates.add(coordinate);

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
