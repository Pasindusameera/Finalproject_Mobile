// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get productName => throw _privateConstructorUsedError;
  Category get category => throw _privateConstructorUsedError;
  String get productDescription => throw _privateConstructorUsedError;
  double get productPrice => throw _privateConstructorUsedError;
  String get productImage => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String productName,
      Category category,
      String productDescription,
      double productPrice,
      String productImage,
      String productId});

  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? category = null,
    Object? productDescription = null,
    Object? productPrice = null,
    Object? productImage = null,
    Object? productId = null,
  }) {
    return _then(_value.copyWith(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      productDescription: null == productDescription
          ? _value.productDescription
          : productDescription // ignore: cast_nullable_to_non_nullable
              as String,
      productPrice: null == productPrice
          ? _value.productPrice
          : productPrice // ignore: cast_nullable_to_non_nullable
              as double,
      productImage: null == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res> get category {
    return $CategoryCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$productImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$productImplCopyWith(
          _$productImpl value, $Res Function(_$productImpl) then) =
      __$$productImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productName,
      Category category,
      String productDescription,
      double productPrice,
      String productImage,
      String productId});

  @override
  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$$productImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$productImpl>
    implements _$$productImplCopyWith<$Res> {
  __$$productImplCopyWithImpl(
      _$productImpl _value, $Res Function(_$productImpl) _then)
      : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? category = null,
    Object? productDescription = null,
    Object? productPrice = null,
    Object? productImage = null,
    Object? productId = null,
  }) {
    return _then(_$productImpl(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      productDescription: null == productDescription
          ? _value.productDescription
          : productDescription // ignore: cast_nullable_to_non_nullable
              as String,
      productPrice: null == productPrice
          ? _value.productPrice
          : productPrice // ignore: cast_nullable_to_non_nullable
              as double,
      productImage: null == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$productImpl implements _product {
  _$productImpl(
      {required this.productName,
      required this.category,
      required this.productDescription,
      required this.productPrice,
      required this.productImage,
      required this.productId});

  factory _$productImpl.fromJson(Map<String, dynamic> json) =>
      _$$productImplFromJson(json);

  @override
  final String productName;
  @override
  final Category category;
  @override
  final String productDescription;
  @override
  final double productPrice;
  @override
  final String productImage;
  @override
  final String productId;

  @override
  String toString() {
    return 'Product(productName: $productName, category: $category, productDescription: $productDescription, productPrice: $productPrice, productImage: $productImage, productId: $productId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$productImpl &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.productDescription, productDescription) ||
                other.productDescription == productDescription) &&
            (identical(other.productPrice, productPrice) ||
                other.productPrice == productPrice) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage) &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productName, category,
      productDescription, productPrice, productImage, productId);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$productImplCopyWith<_$productImpl> get copyWith =>
      __$$productImplCopyWithImpl<_$productImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$productImplToJson(
      this,
    );
  }
}

abstract class _product implements Product {
  factory _product(
      {required final String productName,
      required final Category category,
      required final String productDescription,
      required final double productPrice,
      required final String productImage,
      required final String productId}) = _$productImpl;

  factory _product.fromJson(Map<String, dynamic> json) = _$productImpl.fromJson;

  @override
  String get productName;
  @override
  Category get category;
  @override
  String get productDescription;
  @override
  double get productPrice;
  @override
  String get productImage;
  @override
  String get productId;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$productImplCopyWith<_$productImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
