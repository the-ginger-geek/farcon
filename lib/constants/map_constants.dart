
import 'package:flame/components.dart';

class MapConstants {

  static const scale = 1.0;

  static const mapStartX = 500.0;
  static const mapStartY = 250.0;
  static final topLeft = Vector2(mapStartX, mapStartY);

  static const srcTileSize = 32.0;
  static const destTileSize = scale * srcTileSize;
  static const halfSize = true;
  static const tileHeight = scale * (halfSize ? 8.0 : 16.0);

  static const mapStartCoordinate = waterBorderSize + waterBorderRandomSize;
  static const mapEndCoordinate = cubeSize - (waterBorderSize + waterBorderRandomSize);

  static const cubeSize = 120;
  static const waterBorderSize = 10;
  static const waterBorderRandomSize = 5;
  static const largesDamSize = 4;
  static const damCountMax = 4;

  static const top = 1;
  static const left = 2;
  static const right = 3;
  static const bottom = 4;

  static const grass = 0;
  static const stone = 1;
  static const sand = 2;
  static const water = 3;

}