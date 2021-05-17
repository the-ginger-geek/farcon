import 'dart:math';
import 'dart:ui';

import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/constants/strings.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

import '../game.dart';

const treeSize = 56.0 * MapConstants.scale;
final int treeCount = (MapConstants.cubeSize * 0.35) as int;

class MapTrees extends PositionComponent with HasGameRef<Farcon> {
  @override
  Future<void> onLoad() async {
    await _loadTrees();
  }

  // @override
  // void render(Canvas canvas) {
  //   final size = (MapConstants.cubeSize * MapConstants.srcTileSize) / 2;
  //   canvas.drawRect(Rect.fromLTWH(0, 0, size, size), BasicPalette.black.paint());
  //   super.render(canvas);
  //
  // }

  Future _loadTrees() async {
    int treeCount = Strings.treeSprites.length;
    List<Vector2> treeCoordinates = [];
    for (int i = 0; i < treeCount; i++) {
      final tree = Strings.treeSprites[Random().nextInt(treeCount)];
      final image = await gameRef.images.load(tree);
      final position = _getRandomPoint(savedCoordinates: treeCoordinates);
      final sprite = SpriteComponent(
          position: position,
          size: Vector2.all(treeSize),
          sprite: Sprite(image));
      treeCoordinates.add(position);
      gameRef.add(sprite);
    }
  }

  Vector2 _getRandomPoint({List<Vector2> savedCoordinates = const []}) {
    final mapSize =
        MapConstants.mapEndCoordinate - MapConstants.mapStartCoordinate;
    if (savedCoordinates.isNotEmpty) {
      bool searchingCoordinate = true;
      while (searchingCoordinate) {
        final x = (Random().nextInt(mapSize).toDouble() * MapConstants.destTileSize)/2 - mapSize;
        final y = (Random().nextInt(mapSize).toDouble() * MapConstants.destTileSize)/2 - mapSize;
        final randomVector = Vector2(0, 0);
        if (!savedCoordinates.contains(randomVector)) {
          searchingCoordinate = false;
          return randomVector;
        }
      }
    }

    final x = Random().nextInt(mapSize).toDouble();
    final y = Random().nextInt(mapSize).toDouble();
    return Vector2(x, y);
  }
}
