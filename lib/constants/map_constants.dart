
import 'package:flame/components.dart';

class MapConstants {

  static const scale = 2.0;

  // IsometricMap doesn't render at 0, 0 so this is a hack for now.
  static const xZero = 8 * srcTileSize;
  static const yZero = 9.5 * srcTileSize;

  static const mapStartX = 500.0;
  static const mapStartY = 250.0;
  static final topLeft = Vector2(mapStartX, mapStartY);

  static const srcTileSize = 32.0;
  static const destTileSize = scale * srcTileSize;
  static const halfSize = true;
  static const tileHeight = scale * (halfSize ? 8.0 : 16.0);

  static const cubeSize = 15;
  static const largesDamSize = 2;
  static const damCountMax = 2;
  static const treeCountMax = 20;
  static const treeCountMin = 10;

  static const top = 1;
  static const left = 2;
  static const right = 3;
  static const bottom = 4;

  static const grass = 0;
  static const stone = 1;
  static const sand = 2;
  static const water = 3;

}