
import 'package:flame/components.dart';

class MapConstants {

  static const scale = 2.0;

  static const mapStartX = 356.0;
  static const mapStartY = 204.0;
  static final topLeft = Vector2(mapStartX, mapStartY);

  static const srcTileSize = 32.0;
  static const destTileSize = scale * srcTileSize;
  static const halfSize = true;
  static const tileHeight = scale * (halfSize ? 8.0 : 16.0);

  static const mapRenderBlockSize = 25;
  static const largestDamSize = 7;
  static const smallestDamSize = 1;
  static const damCountMax = 2;
  static const damCountMin = 1;
  static const treeCountMax = 10;
  static const treeCountMin = 2;
  static const grassCountMax = 30;
  static const grassCountMin = 6;
  static const flowerCountMax = 30;
  static const flowerCountMin = 6;
  static const mushroomCountMax = 10;
  static const mushroomCountMin = 6;
  static const treeImageSize = 128;
  static const grassImageSize = 64;
  static const flowerImageSize = 32;
  static const mushroomImageSize = 32;

  static const top = 1;
  static const left = 2;
  static const right = 3;
  static const bottom = 4;

  static const grass = 0;
  static const stone = 1;
  static const sand = 2;
  static const water = 3;

}