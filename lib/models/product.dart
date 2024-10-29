import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sports/config.dart';
import 'package:sports/models/category.dart';

part 'product.freezed.dart';
part 'product.g.dart';

List<Product> productsFromJson(dynamic str) => List<Product>.from((str).map((x) => Product.fromJson(x)));
@freezed
abstract class Product with _$Product {
  factory Product({
    required String productName,
    required Category category,
    required String productDescription,
    required double productPrice,
    required String productImage,
    required String productId,
    
  }) = _product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

extension ProductExt on Product {
  String get fullImagePath => Config.imageURL + productImage;

  
  
}