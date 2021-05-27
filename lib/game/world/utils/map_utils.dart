import 'package:farcon/constants/map_constants.dart';
import 'package:flame/components.dart';

mixin MapUtils {
  Vector2 cartToIso(Vector2 p) {
    final x = (p.x - p.y) * (MapConstants.srcTileSize);
    final y = (p.x + p.y) * (MapConstants.tileHeight);
    return Vector2(x, y);
  }

  Vector2 isoToCart(Vector2 p) {
    final resolvedX = (p.x < 0) ? -p.x : p.x;
    final resolvedY = (p.y < 0) ? -p.y : p.y;
    final x = ((resolvedX / MapConstants.destTileSize) +
            (resolvedY / MapConstants.tileHeight)) / 2;
    final y = ((resolvedY / MapConstants.tileHeight) -
            (resolvedX / MapConstants.destTileSize)) / 2;
    return Vector2(x, y);
  }

  int getPriorityFromCoordinate(Vector2 coordinate) {
    int priority = (0.5 *
                (coordinate.x + coordinate.y) *
                (coordinate.x + coordinate.y + 1) +
            (coordinate.x * coordinate.y))
        .toInt();

    int result = 0;
    if (priority < 0) {
      result = -priority;
    } else {
      result = priority;
    }
    return result;
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
