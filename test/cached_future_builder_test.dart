import 'package:flutter_test/flutter_test.dart';

import 'package:cached_future_builder/cached_future_builder.dart';

void main() {
  test('CacheManager test', () {
    final manager = CacheManager();
    expect(manager, isNotNull);
  });
}
