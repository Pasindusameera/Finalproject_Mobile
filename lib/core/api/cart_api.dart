// core/api/cart_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartAPI {
  final String baseUrl;

  CartAPI({required this.baseUrl});

  // Add an item to the cart
  Future<void> addItemToCart(String userID, String itemID, int quantity) async {
    final url = Uri.parse('$baseUrl/cart/add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userID': userID,
        'itemID': itemID,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 201) {
      print('Item added to cart');
    } else {
      throw Exception('Failed to add item to cart: ${response.body}');
    }
  }

  // Get all cart items for a user
  Future<List<dynamic>> getCartItems(String userID) async {
    final url = Uri.parse('$baseUrl/cart/$userID');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['items'];
    } else {
      throw Exception('Failed to fetch cart items: ${response.body}');
    }
  }

  // Remove an item from the cart
  Future<void> removeItemFromCart(String userID, String itemID) async {
    final url = Uri.parse('$baseUrl/cart/remove');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userID': userID,
        'itemID': itemID,
      }),
    );

    if (response.statusCode == 200) {
      print('Item removed from cart');
    } else {
      throw Exception('Failed to remove item from cart: ${response.body}');
    }
  }

  // Reduce item quantity in the cart
  Future<void> reduceItemQuantity(String userID, String itemID, int quantity) async {
    final url = Uri.parse('$baseUrl/cart/reduce');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userID': userID,
        'itemID': itemID,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      print('Item quantity updated');
    } else {
      throw Exception('Failed to reduce item quantity: ${response.body}');
    }
  }
}