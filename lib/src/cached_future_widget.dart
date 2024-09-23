import 'dart:developer';

import 'package:cached_future_builder/src/cache/cache_manager.dart';
import 'package:cached_future_builder/src/models/base_model.dart';
import 'package:flutter/material.dart';

class CachedFutureWidget<T extends BaseModel> extends StatefulWidget {
  final Future<T> Function() fetchFunction;
  final String cacheKey;
  final Duration? cacheDuration;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? Function(String error)? errorBuilder;
  final Widget? loadingBuilder, onEmptyWidget;
  final bool forceRefresh;
  final T model;

  const CachedFutureWidget({
    super.key,
    required this.fetchFunction,
    required this.cacheKey,
    this.cacheDuration,
    required this.builder,
    required this.model,
    this.forceRefresh = false,
    this.errorBuilder,
    this.loadingBuilder,
    this.onEmptyWidget,
  });

  @override
  _CachedFutureWidgetState<T> createState() => _CachedFutureWidgetState<T>();
}

class _CachedFutureWidgetState<T extends BaseModel> extends State<CachedFutureWidget<T>> {
  final CacheManager cacheManager = CacheManager();

  @override
  void initState() {
    super.initState();
    assert(T is BaseModel, 'T must be a subclass of BaseModel');
    cacheManager.initCache();
  }

  Future<T> _getData() async {
    // Force refresh will delete the cache and fetch the data again
    if (widget.forceRefresh) {
      await cacheManager.deleteData(widget.cacheKey);
    }

    // check the cache first
    final cachedData = cacheManager.getData(widget.cacheKey, widget.model);
    if (cachedData != null && !widget.forceRefresh) {
      return cachedData as T;
    }

    log("CachedFutureWidget._getData: Fetching data from API");

    // fetch the value and save it to cache
    T data = await widget.fetchFunction();
    await cacheManager.saveData(widget.cacheKey, data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingBuilder ?? const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return widget.errorBuilder?.call(snapshot.error.toString()) ?? Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return widget.builder(context, snapshot.data!);
        } else {
          return widget.onEmptyWidget ?? const Center(child: Text('No data available'));
        }
      },
    );
  }
}
