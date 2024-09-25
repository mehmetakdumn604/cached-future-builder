/// A base model class for serialization and deserialization.
///
/// This class provides methods for converting JSON data to a model instance
/// and vice versa.
abstract class BaseModel {
  /// Converts the BaseModel instance to a JSON map.
  ///
  /// This method returns a [Map<String, dynamic>] representation
  /// of the BaseModel instance.
  ///
  /// Example:
  /// ```dart
  /// final json = model.toJson();
  /// ```
  Map<String, dynamic> toJson();

  /// Creates an instance of BaseModel from a JSON map.
  ///
  /// This method takes a [Map<String, dynamic>] as input and returns
  /// an instance of [BaseModel].
  ///
  /// Example:
  /// ```dart
  /// final model = BaseModel.fromJson(jsonMap);
  /// ```
  BaseModel fromJson(Map<String, dynamic> json);
}
