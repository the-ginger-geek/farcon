import 'package:farcon/constants/map_constants.dart';
import 'package:farcon/constants/asset_paths.dart';
import 'package:farcon/world/grassy_block.dart';
import 'package:farcon/world/object_distribution/random_object_distribution.dart';
import 'package:farcon/world/utils/map_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/image_composition.dart';

import 'world/object_distribution/cluster_object_distribution.dart';
import 'world/selector.dart';

class Farcon extends BaseGame
    with MultiTouchDragDetector, MouseMovementDetector, MapUtils {
  Vector2 dragDown = Vector2(0, 0);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // debugMode = true;
    await _loadMap();

    camera.snapTo(Vector2(
      -viewport.effectiveSize.x / 2,
      -viewport.effectiveSize.y / 3,
    ));
  }

  @override
  void onDragStart(int pointerId, Vector2 details) {
    dragDown = Vector2(
      camera.position.x + details.x,
      camera.position.y + details.y,
    );
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateDetails details) {
    final x = dragDown.x - details.globalPosition.dx;
    final y = dragDown.y - details.globalPosition.dy;
    camera.snapTo(Vector2(x, y));
  }

  @override
  void onDragEnd(int pointerId, DragEndDetails details) {}

  Future _loadMap() async {
    final blockSize = MapConstants.mapRenderBlockSize;

    for (double x = 0; x < blockSize*2; x+=blockSize) {
      for (double y = 0; y < blockSize*1; y+=blockSize) {
        final leftTop = Vector2(x, y);
        final grassyBlock = GrassyBlock(
            loadComplete: (waterCoordinates) {
              _grassyBlockBody(leftTop, blockSize, waterCoordinates);
            },
            leftTop: leftTop,
            mapSize: blockSize);
        add(grassyBlock);
      }
    }
  }

  void _grassyBlockBody(Vector2 leftTop, int blockSize, List<Vector2> waterCoordinates) {
    add(RandomObjectDistribution(
      leftTop: leftTop,
      sprites: AssetPaths.grassSprites,
      seedCountMax: MapConstants.grassCountMax,
      seedCountMin: MapConstants.grassCountMin,
      imageSize: MapConstants.grassImageSize,
      blockSize: blockSize,
      noDrawCoordinates: waterCoordinates,
      centerImageTo: CenterTo.CENTER,
    ));
    add(ClusterObjectDistribution(
      leftTop: leftTop,
      radiusSizeMin: 1,
      radiusSizeMax: 3,
      sprites: AssetPaths.flowerSprites,
      clusterCountMax: 5,
      clusterCountMin: 2,
      priority: 1,
      imageSize: MapConstants.flowerImageSize,
      blockSize: blockSize,
      noDrawCoordinates: waterCoordinates,
    ));
    add(ClusterObjectDistribution(
      leftTop: leftTop,
      radiusSizeMin: 1,
      radiusSizeMax: 2,
      sprites: AssetPaths.mushroomSprites,
      clusterCountMax: 3,
      clusterCountMin: 0,
      priority: 1,
      imageSize: MapConstants.mushroomImageSize,
      blockSize: blockSize,
      noDrawCoordinates: waterCoordinates,
    ));
    // add(ClusterObjectDistribution(
    //   radiusSizeMin: 1,
    //   radiusSizeMax: 2,
    //   sprites: AssetPaths.treeSprites,
    //   clusterCountMax: 5,
    //   clusterCountMin: 4,
    //   priority: 2,
    //   imageSize: MapConstants.treeImageSize,
    //   mapSize: MapConstants.mapSize,
    //   noDrawCoordinates: waterCoordinates,
    // ));
    add(RandomObjectDistribution(
      leftTop: leftTop,
      sprites: AssetPaths.treeSprites,
      seedCountMax: MapConstants.treeCountMax,
      seedCountMin: MapConstants.treeCountMin,
      imageSize: MapConstants.treeImageSize,
      priority: 3,
      blockSize: blockSize,
      noDrawCoordinates: waterCoordinates,
    ));
  }
}
