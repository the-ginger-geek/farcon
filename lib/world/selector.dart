import 'dart:ui';

import 'package:farcon/constants/map_constants.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class Selector extends SpriteComponent {
  bool show = false;

  Selector(Image image)
      : super(
    sprite: Sprite(image, srcSize: Vector2.all(32.0)),
    size: Vector2.all(MapConstants.destTileSize),
    overridePaint: BasicPalette.black.paint(),
  );

  @override
  void render(Canvas canvas) {
    if (!show) {
      return;
    }

    super.render(canvas);
  }
}