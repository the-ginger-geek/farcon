import 'package:farcon/constants/map_constants.dart';
import 'package:flame/components.dart';

mixin MapUtils {
  Vector2 cartToIso(Vector2 p) {
    final x = (p.x - p.y) * (MapConstants.srcTileSize);
    final y = (p.x + p.y) * (MapConstants.tileHeight);
    return Vector2(x, y);
  }

  Vector2 isoToCart(Vector2 p) {
    final x = (p.x / MapConstants.destTileSize) + (p.y / MapConstants.tileHeight);
    final y = (p.y / MapConstants.tileHeight) - (p.x / MapConstants.destTileSize);
    return Vector2(x, y);
  }

  Vector2 alignCoordinateToImage(
      Vector2 coordinate, int imageWidth, int imageHeight,
      {CenterTo centerTo = CenterTo.CENTER}) {
    switch (centerTo) {
      case CenterTo.CENTER:
        return Vector2(
            coordinate.x - imageWidth / 2, coordinate.y - imageHeight / 2);
      case CenterTo.CENTER_LEFT:
        return Vector2(coordinate.x, coordinate.y - imageHeight / 2);
      case CenterTo.CENTER_RIGHT:
        return Vector2(
            coordinate.x - imageWidth, coordinate.y - imageHeight / 2);
      case CenterTo.CENTER_BOTTOM:
        return Vector2(
            coordinate.x - imageWidth / 2, coordinate.y - imageHeight);
      case CenterTo.CENTER_TOP:
        return Vector2(coordinate.x - imageWidth / 2, coordinate.y);
      case CenterTo.LEFT_TOP:
        return coordinate;
      case CenterTo.LEFT_BOTTOM:
        return Vector2(coordinate.x, coordinate.y - imageHeight);
      case CenterTo.RIGHT_TOP:
        return Vector2(coordinate.x - imageWidth, coordinate.y);
      case CenterTo.RIGHT_BOTTOM:
        return Vector2(coordinate.x - imageWidth, coordinate.y - imageHeight);
    }
  }
}
enum CenterTo {
  CENTER,
  CENTER_LEFT,
  CENTER_RIGHT,
  CENTER_TOP,
  CENTER_BOTTOM,
  LEFT_BOTTOM,
  LEFT_TOP,
  RIGHT_TOP,
  RIGHT_BOTTOM,
}
