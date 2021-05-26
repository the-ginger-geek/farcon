import 'package:farcon/constants/hive_types.dart';
import 'package:flame/components.dart';
import 'package:hive/hive.dart';

import 'hive_vector2.dart';

@HiveType(typeId: HiveTypes.resourceItem)
class ResourceItem {
  @HiveField(0)
  final int resourceType;
  @HiveField(1)
  final int drawableIndex;
  @HiveField(2)
  late HiveVector2 coordinate;

  ResourceItem({
    required this.resourceType,
    required this.drawableIndex,
    required Vector2 coordinate,
  }) {
    this.coordinate = HiveVector2.of(coordinate);
  }

  @override
  String toString() {
    return 'ResourceItem($resourceType, $drawableIndex, $coordinate)';
  }
}
