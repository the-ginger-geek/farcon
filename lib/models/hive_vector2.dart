
import 'dart:typed_data';

import 'package:farcon/constants/hive_types.dart';
import 'package:flame/components.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: HiveTypes.hiveVector2)
class HiveVector2 {
  @HiveField(0)
  final double x;
  @HiveField(1)
  final double y;

  HiveVector2(this.x, this.y);

  factory HiveVector2.of(Vector2 vector2) {
    return HiveVector2(vector2.x, vector2.y);
  }

  Vector2 toVector2() => Vector2(x, y);
}