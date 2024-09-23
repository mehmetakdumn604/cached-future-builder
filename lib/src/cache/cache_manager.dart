import 'dart:convert';
import 'dart:developer';

import 'package:cached_future_builder/src/models/base_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  Box? _cacheBox;

  factory CacheManager() {
    _instance.initCache();

    return _instance;
  }

  CacheManager._internal();

  Future<void> initCache() async {
    if (!Hive.isBoxOpen('cacheBox')) {
      await Hive.initFlutter();
      _cacheBox = await Hive.openBox('cacheBox');
    } else {
      _cacheBox = Hive.box('cacheBox');
    }
  }

  Future<void> saveData(String key, BaseModel model) async {
    try {
      await _cacheBox?.put(key, jsonEncode(model.toJson()));
    } catch (e) {
      log('CacheManager.saveData: $e');
    }
  }

  BaseModel? getData(String key, BaseModel model) {
    final jsonData = _cacheBox?.get(key);
    if (jsonData != null) {
      log('CacheManager.getData: $jsonData cache data');
      return model.fromJson(jsonDecode(jsonData));
    }
    return null;
  }

  Future<void> deleteData(String key) async {
    await _cacheBox?.delete(key);
  }
}
