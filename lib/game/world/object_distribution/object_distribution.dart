import 'dart:math';

import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/game/world/utils/map_utils.dart';
import 'package:farcon/models/resource_item.dart';
import 'package:flame/components.dart';

import '../../game.dart';

abstract class ObjectDistribution extends PositionComponent
    with HasGameRef<Farcon>, MapUtils {
  final Vector2 leftTop;
  final List<String> sprites;
  final int resourceType;
  final int seedCountMax;
  final int seedCountMin;
  final int imageSize;
  final int blockSize;
  final CenterTo centerImageTo;
  final List<Vector2> noDrawCoordinates;
  final List<ResourceItem> distributionCoordinates = [];
  final Function(List<ResourceItem> distributionCoordinates)? callback;

  ObjectDistribution({
    required this.resourceType,
    required this.sprites,
    required this.leftTop,
    required this.seedCountMax,
    required this.seedCountMin,
    required this.imageSize,
    required this.blockSize,
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
      final drawableIndex = Random().nextInt(count);
      final spriteString = sprites[drawableIndex];
      distributionCoordinates.add(ResourceItem(
        resourceType: resourceType,
        drawableIndex: drawableIndex,
        coordinate: coordinate,
      ));

      final image = await gameRef.images.load(spriteString);
      final isoPosition = cartToIso(coordinate);
      await gameRef.add(PositionedSprite(
        sprite: SpriteComponent.fromImage(image),
        priority: getPriorityFromCoordinate(coordinate),
        position: alignCoordinateToImage(
          isoPosition,
          imageSize,
          imageSize - MapConstants.destTileSize ~/ 3,
          centerTo: centerImageTo,
        ),
      ));
    }
  }

  List<Vector2> getLocations();
}

class PositionedSprite extends PositionComponent {
  final SpriteComponent sprite;
  final int priority;
  final Vector2 position;

  PositionedSprite({
    required this.sprite,
    required this.priority,
    required this.position,
  }) : super(priority: priority, position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    addChild(sprite);
  }
}
