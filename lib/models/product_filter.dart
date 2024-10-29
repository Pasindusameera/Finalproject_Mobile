import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_filter.freezed.dart';
 

@freezed
class ProductFilterModel with _$ProductFilterModel {
  factory ProductFilterModel({
    required PaginationModel paginationModel,
    String? categoryId,
  }) = _ProductFilterModel;
}

class PaginationModel {
  final int page;      // Ensure this field is defined
  final int pageSize;  // Ensure this field is defined

  PaginationModel({
    required this.page,
    required this.pageSize,
  });
}

