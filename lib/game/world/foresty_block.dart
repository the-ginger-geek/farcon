import 'dart:math';

import 'package:farcon/constants/store_keys.dart';
import 'package:farcon/dependency_injection/service_locator.dart';
import 'package:farcon/store/data_store.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../constants/map_constants.dart';
import '../../constants/asset_paths.dart';
import '../../constants/resource_constants.dart';
import '../../game/game.dart';
import '../../game/world/utils/map_utils.dart';
import '../../models/resource_item.dart';
import '../../models/circle.dart';
import '../../models/map_block.dart';
import 'object_distribution/cluster_object_distribution.dart';
import 'object_distribution/random_object_distribution.dart';

class ForestyBlock extends PositionComponent with HasGameRef<Farcon>, MapUtils {
  late IsometricTileMapComponent _map;
  final int blockSize;
  final Vector2 leftTop;
  late DataStore dataStore;

  List<Vector2> waterCoordinates = [];

  ForestyBlock({
    required this.blockSize,
    required this.leftTop,
  });

  @override
  Future<void> onLoad() async {
    dataStore = await locator.getAsync<DataStore>();
    await _loadMap();

    _drawMapComponents();
  }

  Block getBlock(Vector2 screenPosition) => _map.getBlock(screenPosition);

  bool containsBlock(Block block) => _map.containsBlock(block);

  Vector2 getBlockPosition(Block block) => _map.getBlockPosition(block);

  Future _loadMap() async {
    final image = await gameRef.images.load(AssetPaths.mapTileSprite);
    final tileset = SpriteSheet(
      image: image,
      srcSize: Vector2.all(MapConstants.srcTileSize),
    );

    final mapPosition = cartToIso(leftTop);
    gameRef.add(_map = IsometricTileMapComponent(
      tileset,
      buildMap(),
      position:
          Vector2(mapPosition.x, mapPosition.y + MapConstants.destTileSize / 2),
      destTileSize: Vector2.all(MapConstants.destTileSize),
    ));
  }

  List<List<int>> buildMap() {
    final dams = _generateDams();

    List<List<int>> matrix = [];

    for (double row = leftTop.y; row < leftTop.y + blockSize; row++) {
      List<int> rowTiles = [];
      for (double column = leftTop.x;
          column < leftTop.x + blockSize;
          column++) {
        if (_drawDams(dams, column, row, rowTiles)) continue;

        rowTiles.add(MapConstants.grass);
      }
      matrix.add(rowTiles);
    }

    return matrix;
  }

  List<Circle> _generateDams() {
    List<Circle> dams = [];
    int damCount = Random().nextInt(MapConstants.damCountMax);

    if (damCount < MapConstants.damCountMax)
      damCount = MapConstants.damCountMin;

    for (int i = 0; i < damCount; i++) {
      final Vector2 damCenter = Vector2(
        (Random().nextInt(leftTop.x.toInt() + blockSize)).toDouble(),
        (Random().nextInt(leftTop.y.toInt() + blockSize)).toDouble(),
      );

      int radius = Random().nextInt(MapConstants.largestDamSize);
      if (radius < MapConstants.smallestDamSize) {
        radius = MapConstants.smallestDamSize;
      }
      dams.add(Circle(damCenter, radius));
    }
    return dams;
  }

  /*
   * Equation for getting dam coordinates for radius and size.
   */
  bool _drawDams(List<Circle> dams, double x, double y, List<int> rowTiles) {
    bool hasDam = false;
    for (Circle dam in dams) {
      final xCoordinate = (x - dam.coords.x) * (x - dam.coords.x);
      final yCoordinate = (y - dam.coords.y) * (y - dam.coords.y);
      final damSize = dam.radius * dam.radius;
      final damPoint = (xCoordinate + yCoordinate) <= damSize;
      if (damPoint) {
        rowTiles.add(MapConstants.water);
        waterCoordinates.add(Vector2(x, y));
        hasDam = true;
      }
    }
    return hasDam;
  }

  void _drawMapComponents() {
    gameRef.add(RandomObjectDistribution(
        resourceType: ResourceConstants.grass,
        leftTop: leftTop,
        sprites: AssetPaths.grassSprites,
        seedCountMax: MapConstants.grassCountMax,
        seedCountMin: MapConstants.grassCountMin,
        imageSize: MapConstants.grassImageSize,
        blockSize: blockSize,
        noDrawCoordinates: waterCoordinates,
        centerImageTo: CenterTo.CENTER,
        callback: (grassCoordinates) {
          gameRef.add(ClusterObjectDistribution(
              resourceType: ResourceConstants.flower,
              leftTop: leftTop,
              radiusSizeMin: 1,
              radiusSizeMax: 5,
              sprites: AssetPaths.flowerSprites,
              clusterCountMax: 5,
              clusterCountMin: 2,
              imageSize: MapConstants.flowerImageSize,
              blockSize: blockSize,
              noDrawCoordinates: waterCoordinates,
              callback: (flowerCoordinates) {
                gameRef.add(ClusterObjectDistribution(
                    resourceType: ResourceConstants.mushroom,
                    leftTop: leftTop,
                    radiusSizeMin: 1,
                    radiusSizeMax: 2,
                    sprites: AssetPaths.mushroomSprites,
                    clusterCountMax: 3,
                    clusterCountMin: 1,
                    imageSize: MapConstants.mushroomImageSize,
                    blockSize: blockSize,
                    noDrawCoordinates: waterCoordinates,
                    callback: (mushroomCoordinates) {
                      gameRef.add(ClusterObjectDistribution(
                          resourceType: ResourceConstants.tree,
                          leftTop: leftTop,
                          radiusSizeMin: 1,
                          radiusSizeMax: 3,
                          sprites: AssetPaths.treeSprites,
                          clusterCountMax: 2,
                          clusterCountMin: 1,
                          imageSize: MapConstants.treeImageSize,
                          blockSize: blockSize,
                          noDrawCoordinates: waterCoordinates,
                          callback: (clusterTreeCoordinates) {
                            gameRef.add(RandomObjectDistribution(
                                resourceType: ResourceConstants.tree,
                                leftTop: leftTop,
                                sprites: AssetPaths.treeSprites,
                                seedCountMax: MapConstants.treeCountMax,
                                seedCountMin: MapConstants.treeCountMin,
                                imageSize: MapConstants.treeImageSize,
                                blockSize: blockSize,
                                noDrawCoordinates: waterCoordinates,
                                callback: (randomTreeCoordinates) {
                                  _saveData([
                                    grassCoordinates,
                                    flowerCoordinates,
                                    mushroomCoordinates,
                                    randomTreeCoordinates,
                                    clusterTreeCoordinates,
                                  ]);
                                }));
                          }));
                    }));
              }));
        }));
  }

  void _saveData(List<List<ResourceItem>> resourceCoordinates) {
    final matrix = _map.matrix;
    final List<ResourceItem> resourceItems = [];
    for (double row = 0; row < matrix.length; row++) {
      final data = matrix[row.toInt()];
      for (double column = 0; column < data.length; column++) {
        final coordinate = Vector2(column + leftTop.x, row + leftTop.y);
        ResourceItem? resourceItem;
        resourceList:
        for (var resourceList in resourceCoordinates) {
          for (var resource in resourceList) {
            if (resource.coordinate.toVector2() == coordinate) {
              resourceItem = resource;
              break resourceList;
            }
          }
        }

        if (resourceItem != null) resourceItems.add(resourceItem);
      }
    }

    dataStore.save(
      storeKey: '${StoreKeys.mapBlock}.$leftTop',
      data: MapBlock(
          positionId: leftTop, matrix: _map.matrix, resources: resourceItems),
    );
  }
}
