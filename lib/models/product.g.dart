// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$productImpl _$$productImplFromJson(Map<String, dynamic> json) =>
    _$productImpl(
      productName: json['productName'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      productDescription: json['productDescription'] as String,
      productPrice: (json['productPrice'] as num).toDouble(),
      productImage: json['productImage'] as String,
      productId: json['productId'] as String,
    );

Map<String, dynamic> _$$productImplToJson(_$productImpl instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'category': instance.category,
      'productDescription': instance.productDescription,
      'productPrice': instance.productPrice,
      'productImage': instance.productImage,
      'productId': instance.productId,
    };
