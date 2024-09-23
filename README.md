cached_future_builder
========================

A Flutter package to manage caching of data fetched from a Future using fromJson and toJson methods for serialization and deserialization. This package allows you to cache data and fetch it later, with support for custom cache durations and force refresh functionality.

Features
--------

*   **Automatic Caching**: Data fetched from a Future is cached locally using Hive.
    
*   **Custom Cache Duration**: Optionally specify how long the cached data is valid.
    
*   **Force Refresh**: Force a refresh to bypass the cache and fetch fresh data.
    
*   **Model Serialization**: Uses fromJson and toJson methods for models to handle serialization.
    

Installation
------------

1.  yaml code 
    dependencies:                       
        flutter_cached_package:
        <br/>
        &nbsp;&nbsp;&nbsp;   git:  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;       url: https://github.com/your-repo/flutter_cached_package.git
    <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ref: main
    
2.  Run flutter pub get to install the package.
    
3.  main.dart code
```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if you wanna fast loading for caching system then run/or remove comment this line
  // await CacheManager().initCache();

  runApp(const MyApp());
}
  ```
  

Usage
-----

### Define a Model

Create a model class that extends BaseModel and implements the fromJson and toJson methods.

```

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


```

### Use CachedFutureWidget to Cache Data

Wrap your fetching logic with CachedFutureWidget, providing the fetch function, cache key, model, and builder.

```
import 'package:flutter/material.dart';
import 'package:flutter_cached_package/flutter_cached_package.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Cached Future Example')),
        body: CachedFutureWidget<MyModel>(
          fetchFunction: () async {
            // Simulate a network request with a delay
            await Future.delayed(Duration(seconds: 2));
            return MyModel(name: 'John Doe', age: 30);
          },
          cacheKey: 'my_model_data',
          model: MyModel(name: '', age: 0), // Default/Empty model instance
          cacheDuration: Duration(minutes: 10), // Optional cache duration
          forceRefresh: false, // Set true to force refresh and bypass cache
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

```

### CacheManager

CacheManager handles all the caching operations. You can also interact with the cache manually if needed:
```
final CacheManager cacheManager = CacheManager();
await cacheManager.initCache();

// Save data
await cacheManager.saveData('key', MyModel(name: 'John Doe', age: 30));

// Retrieve data
MyModel? model = cacheManager.getData('key', MyModel(name: '', age: 0));

// Delete data
await cacheManager.deleteData('key');

```
Parameters
----------

*   **fetchFunction**: The asynchronous function that fetches the data.
    
*   **cacheKey**: A unique string used to store and retrieve the cached data.
    
*   **model**: The default model instance that is used for deserializing the cached data.
    
*   **cacheDuration**: (Optional) How long the cache is valid. If not provided, cache is considered valid indefinitely.
    
*   **forceRefresh**: (Optional) If true, the cache is ignored, and new data is fetched. Default value is false.
    
*   **builder**: A widget builder function that takes the fetched or cached data and builds a widget.
    

Example
-------
```
CachedFutureWidget<MyModel>(
  fetchFunction: () async {
    await Future.delayed(Duration(seconds: 2));
    return MyModel(name: 'John Doe', age: 30);
  },
  cacheKey: 'my_model_data',
  model: MyModel(name: '', age: 0),
  cacheDuration: Duration(minutes: 10),
  forceRefresh: false,
  builder: (context, data) {
    return Text('Name: ${data.name}, Age: ${data.age}');
  },
)

```

Testing
-------

To run the tests:

```
flutter test
```

License
-------

This package is licensed under the MIT License.