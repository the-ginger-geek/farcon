import 'package:farcon/constants/map_constants.dart';
import 'package:flame/components.dart';

import '../game.dart';
import 'foresty_block.dart';
import 'utils/map_utils.dart';

class GameMap extends PositionComponent with HasGameRef<Farcon>, MapUtils {
  final int blockSize = MapConstants.mapRenderBlockSize;
  final Function(Vector2 mapCenter) callback;
  Vector2 mapCorner = Vector2(0, 0);
  Vector2 lastBlockPosition = Vector2(0, 0);

  GameMap({required this.callback}) : super(priority: -999999999999999999);

  @override
  Future<void> onLoad() async {
    addBlock(Vector2(mapCorner.x - blockSize, mapCorner.y - blockSize), priority: -1); //leftTop
    addBlock(Vector2(mapCorner.x - blockSize, mapCorner.y + blockSize), priority: -1); //leftBottom
    addBlock(Vector2(mapCorner.x - blockSize, mapCorner.y), priority: -1); //left
    addBlock(Vector2(mapCorner.x, mapCorner.y - blockSize), priority: -1); //top
    addBlock(Vector2(mapCorner.x, mapCorner.y), priority: 0);
    addBlock(Vector2(mapCorner.x + blockSize, mapCorner.y - blockSize), priority: 1); //rightTop
    addBlock(Vector2(mapCorner.x + blockSize, mapCorner.y), priority: 1); //right
    addBlock(Vector2(mapCorner.x, mapCorner.y + blockSize), priority: 1); //bottom
    addBlock(Vector2(mapCorner.x + blockSize, mapCorner.y + blockSize), priority: 1); //rightBottom

    callback.call(Vector2((mapCorner.x + blockSize) / 2, (mapCorner.x + blockSize) / 2));
  }

  void addBlock(Vector2 leftTop, {int priority = -999999999999999999}) {
    addChild(ForestyBlock(
      leftTop: leftTop,
      blockSize: blockSize,
      gameRef: gameRef,
      priority: priority,
    ));
  }

  void updateMap() {
    final viewPortSize = gameRef.viewport.canvasSize;
    final camPos = gameRef.camera.position;
    final characterPosition = Vector2(
        camPos.x + (viewPortSize.x / 2), camPos.y + (viewPortSize.y / 2));
    final camCart = isoToCart(characterPosition);
    final cX = camCart.x;
    final cY = camCart.y;
    final borders = Vector2(lastBlockPosition.x + blockSize, lastBlockPosition.y + blockSize);
    if (cX > borders.x && cY < borders.y) {
      
    }
  }
}
