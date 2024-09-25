cached_future_builder
========================
## Created by [@mehmetakduman](https://github.com/mehmetakdumn604)

cached_future_builder is a Flutter package designed to simplify the management of asynchronous data fetching by providing built-in caching functionality. This package allows you to cache data retrieved from a Future and access it later, significantly improving application performance and enhancing user experience, especially when fetching data over the network.

Key Features:
--------

*   **Automatic Caching**: The cached_future_builder automatically caches the results obtained from a Future. This means that when the same data is requested again, the package can serve it from the cache, providing a faster response time and reducing the need for repeated network calls.
    
*   **Custom Cache Duration**: Users can specify how long the cached data should remain valid. This feature enables you to control the cache lifetime, ensuring that you can refresh the data when necessary while still benefiting from the speed of cached responses.
    
*   **Force Refresh**: The package provides a way to forcefully refresh the cached data when needed. This is particularly useful for scenarios where it’s crucial for users to access the most up-to-date information, allowing you to bypass the cache and fetch new data directly from the network.
    
*   **Model Serialization**: The package supports easy serialization and deserialization of data through fromJson and toJson methods. This allows you to work seamlessly with your own data models and effectively manage the data flow in your application.


Use Cases:
----------
Social Media Applications: You can leverage the caching feature to quickly display user profiles, posts, or comments, enhancing the overall user experience.

E-Commerce Applications: The package is ideal for caching product details, user reviews, or promotional offers, allowing for faster load times and improved responsiveness.

Weather Applications: Frequently updating weather data can benefit from this package, ensuring users receive the latest information efficiently.

cached_future_builder is a valuable tool for modern Flutter applications aiming to enhance performance and user experience through effective data caching. If you’re looking for a reliable and flexible solution, consider integrating this package into your projects.


    

Installation
------------

1.  yaml code
```
    dependencies:                       
        cached_future_builder: ^1.0.5
```
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