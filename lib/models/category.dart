import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart'; // Include this if you are using JSON serialization

@freezed
class Category with _$Category {
  const factory Category({
    required String categoryName, // Assuming this is a required field
    required String fullImagePath, // This should also be required
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}
