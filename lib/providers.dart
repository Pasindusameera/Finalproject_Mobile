import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/api/api_service.dart';
import 'package:sports/models/category.dart';
import 'package:sports/models/pagination.dart';
import 'package:sports/models/product.dart';
import 'package:sports/models/product_filter.dart';
// ignore: unused_import
import 'package:sports/widgets/widget_home_products.dart'; 

final categoriesProvider = FutureProvider.family<List<Category>?, Pagination>(
  (ref, pagination) async {
    // Watch the API service
    final apiRepository = ref.watch(apiService);

    // Call the API to get categories, handle exceptions as necessary
    
      return await apiRepository.getCategories(
        pagination.pageNumber, 
        pagination.pageSize,   
      );
    }, 
 
);
final HomeProductProvider = 
    FutureProvider.family<List<Product>?, ProductFilterModel>(
      (ref,productFilterModel){
        final apiRespository = ref.watch(apiService);

        return apiRespository.getProducts(productFilterModel);
      },

    );
