
import 'package:farcon/constants/store_keys.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@injectable
class DataStore {
  final _fieldKey = 'cached_item';

  final List<String> registry = [
    StoreKeys.mapBlock,
  ];

  @preResolve
  @factoryMethod
  static Future<DataStore> initialize() async {
    DataStore cache = DataStore._();
    var futures = <Future>[];
    for (String storeKey in cache.registry) {
      futures.add(Hive.openBox(storeKey));
    }
    await Future.wait(futures);

    return cache;
  }

  DataStore._();

  Future save<T>({
    required String storeKey,
    required T data,
  }) async {
    Box storeBox = await _openCache(storeKey);
    await _addToCache(data, storeBox);
  }

  Future<T> get<T>({
    required String storeKey,
  }) async {
    Box cacheBox = await _openCache(storeKey);
    return cacheBox.get(_fieldKey);
  }

  Future<Box> _openCache(String storeKey) async {
    if (Hive.isBoxOpen(storeKey)) {
      return Hive.box(storeKey);
    }

    return await Hive.openBox(storeKey);
  }

  Future<void> _addToCache(data, Box box) async {
    if (data is HiveObject) {
      box.put(_fieldKey, data);
    }
  }

  Future<void> dispose() async {
    var futures = <Future>[];
    for (String storeKey in registry) {
      futures.add(Hive.box(storeKey).close());
    }
    await Future.wait(futures);
  }

  Future<void> clear() async {
    var futures = <Future>[];
    for (String storeKey in registry) {
      futures.add(Hive.deleteBoxFromDisk(storeKey));
    }
    await Future.wait(futures);
  }
}