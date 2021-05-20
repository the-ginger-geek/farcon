
import 'package:flame/game.dart';

class Circle {
  final Vector2 coords;
  final int radius;

  Circle(this.coords, this.radius);

  @override
  String toString() {
    return 'Circle([${coords.x}, ${coords.y}], $radius)';
  }
}