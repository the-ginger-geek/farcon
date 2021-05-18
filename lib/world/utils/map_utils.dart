
import 'package:farcon/constants/map_constants.dart';
import 'package:flame/components.dart';

mixin MapUtils {
  Vector2 cartToIso(Vector2 p) {
    final x = (p.x - p.y) * (MapConstants.srcTileSize);
    final y = (p.x + p.y) * (MapConstants.tileHeight);
    return Vector2(x, y);
  }
}