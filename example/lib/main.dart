import 'package:cached_future_builder/src/cached_future_widget.dart';
import 'package:cached_future_builder/src/models/base_model.dart';
import 'package:flutter/material.dart';

class MyModel extends BaseModel {
  final String name;
  final int age;

  MyModel({required this.name, required this.age});

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }

  @override
  MyModel fromJson(Map<String, dynamic> json) {
    return MyModel(
      name: json['name'],
      age: json['age'],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if you wanna fast loading for caching system then run/or remove comment this line
  // await CacheManager().initCache();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Cached Future Example')),
        body: CachedFutureWidget<MyModel>(
          fetchFunction: () async {
            await Future.delayed(const Duration(seconds: 2));
            return MyModel(name: 'John Doe', age: 30);
          },
          cacheKey: 'my_model_data',
          model: MyModel(name: '', age: 0),
          builder: (context, data) {
            return Center(
              child: Text('Name: ${data.name}, Age: ${data.age}'),
            );
          },
        ),
      ),
    );
  }
}
