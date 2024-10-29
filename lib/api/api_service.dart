import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:sports/config.dart';
import 'package:sports/models/product.dart';
import 'package:sports/models/product_filter.dart';

// Provider for ApiService
final apiService = Provider((ref) => ApiService());

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  // Fetch categories from the API
  Future<List<Category>?> getCategories(int page, int pageSize) async {
    final Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    final Map<String, String> queryString = {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };

    final url = Uri.http(Config.apiURL, Config.categoryAPI, queryString);

    try {
      final response = await client.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return categoriesFromJson(data["data"]);
      } else {
        // Handle response error
        print('Failed to load categories: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Consider logging or throwing an exception
      print('Error fetching categories: $e');
      return null;
    }
  }

  // Fetch products based on filter criteria
  Future<List<Product>?> getProducts(ProductFilterModel productFilterModel) async {
    final Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    final Map<String, String> queryString = {
      'page': productFilterModel.paginationModel.page.toString(),
      'pageSize': productFilterModel.paginationModel.pageSize.toString(),

      if (productFilterModel.categoryId != null) 'categoryId': productFilterModel.categoryId!,
    };

    final url = Uri.http(Config.apiURL, Config.productAPI, queryString);

    try {
      final response = await client.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return productsFromJson(data["data"]);
      } else {
        // Handle response error
        print('Failed to load products: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Consider logging or throwing an exception
      print('Error fetching products: $e');
      return null;
    }
  }
}

// Parse JSON response for categories
List<Category> categoriesFromJson(List<dynamic> data) {
  return data.map((json) => Category.fromJson(json)).toList();
}

// Parse JSON response for products
List<Product> productsFromJson(List<dynamic> data) {
  return data.map((json) => Product.fromJson(json)).toList();
}
