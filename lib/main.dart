import 'dart:io';

import 'package:farcon/store/store_adapters.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'dependency_injection/service_locator.dart';
import 'game/game.dart';

void main() async {
  configureDependencies();
  await _initialiseNetworkCache();

  runApp(
    GameWidget(
      game: Farcon(),
      backgroundBuilder: (context) {
        return Container(color: Colors.amber);
      },
      overlayBuilderMap: {
        'PauseMenu': (ctx, _) {
          return Text('A pause menu');
        },
      },
    ),
  );
}

Future _initialiseNetworkCache() async {
  String? appDocumentDir;
  try {
    final validPlatform = Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isWindows ||
        Platform.isLinux ||
        Platform.isMacOS ||
        Platform.isFuchsia;
    appDocumentDir =
        validPlatform ? (await getApplicationDocumentsDirectory()).path : './';
  } catch (e) {
    appDocumentDir = './';
  }

  Hive.init(appDocumentDir);
  StoreAdapters.registerAdapters();
}

void dispose() {
  Hive.close();
}
