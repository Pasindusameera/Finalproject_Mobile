// core/api/wishlist_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class WishlistAPI {
  final String baseUrl;

  WishlistAPI({required this.baseUrl});

  // Add an item to the wishlist
  Future<void> addItemToWishlist(String userID, String itemID) async {
    final url = Uri.parse('$baseUrl/add'); // API endpoint for adding an item
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userID': userID,
        'itemID': itemID,
      }),
    );

    if (response.statusCode == 201) {
      print('Item added to wishlist');
    } else {
      throw Exception('Failed to add item to wishlist: ${response.body}');
    }
  }

  // Get all wishlist items for a user
  Future<List<dynamic>> getWishlistItems(String userID) async {
    final url = Uri.parse('$baseUrl/$userID'); // API endpoint for fetching items
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['items']; // Adjust based on actual API response structure
    } else {
      throw Exception('Failed to fetch wishlist items: ${response.body}');
    }
  }

Future<void> removeItemFromWishlist(String userID, String itemID) async {
  final url = Uri.parse('$baseUrl/remove'); // Ensure this is the correct endpoint
  final response = await http.delete(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userID': userID,
      'itemID': itemID,
    }),
  );

  if (response.statusCode == 200) {
    print('Item removed from wishlist');
  } else {
    throw Exception('Failed to remove item from wishlist: ${response.body}');
  }
}
}