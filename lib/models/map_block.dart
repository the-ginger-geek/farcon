import 'package:flame/components.dart';
import 'package:hive/hive.dart';

import '../constants/hive_types.dart';
import 'hive_vector2.dart';
import 'resource_item.dart';

@HiveType(typeId: HiveTypes.mapBlock)
class MapBlock {
  @HiveField(0)
  late HiveVector2 positionId;
  @HiveField(1)
  final List<List<int>> matrix;
  @HiveField(2)
  final List<ResourceItem> resources;

  MapBlock({
    required Vector2 positionId,
    required this.matrix,
    required this.resources,
  }) {
   this.positionId = HiveVector2.of(positionId);
  }

  @override
  String toString() {
    return 'MapBlock($positionId\nresources: $resources\nmatrix: $matrix)';
  }
}
