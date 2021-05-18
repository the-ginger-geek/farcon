import 'dart:math';

import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/constants/strings.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flame/components.dart';

import '../game.dart';

class MapTrees extends PositionComponent with HasGameRef<Farcon>, MapUtils {
  @override
  Future<void> onLoad() async {
    await _loadTrees();
  }

  Future _loadTrees() async {
    int treeSpritesCount = Strings.treeSprites.length;
    final coordinates = _getTreeLocations();
    for (var treeCoordinate in coordinates) {
      final tree = Strings.treeSprites[Random().nextInt(treeSpritesCount)];
      final image = await gameRef.images.load(tree);
      final isoPosition = cartToIso(treeCoordinate);
      final sprite = SpriteComponent.fromImage(
        image,
        position: alignCoordinateToImage(
          isoPosition,
          MapConstants.treeImageSize,
          MapConstants.treeImageSize - MapConstants.destTileSize ~/ 3,
          centerTo: CenterTo.CENTER_BOTTOM,
        ),
      );
      await gameRef.add(sprite);
    }
  }

  List<Vector2> _getTreeLocations() {
    final size = MapConstants.mapSize;
    int treeCount = Random().nextInt(MapConstants.treeCountMax);
    if (treeCount < MapConstants.treeCountMin)
      treeCount = MapConstants.treeCountMin;

    List<Vector2> treeCoordinates = [];
    for (int i = 0; i < treeCount; i++) {
      final x = Random().nextInt(size).toDouble();
      final y = Random().nextInt(size).toDouble();
      treeCoordinates.add(Vector2(x, y));
    }

    treeCoordinates.sort((a, b) => a.y > b.y || a.x > b.x ? 1 : 0);

    return treeCoordinates;
  }
}
