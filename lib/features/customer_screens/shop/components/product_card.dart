// features/customer_screens/shop/components/product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playhub/core/api/wishlist_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(bool) onFavoriteToggle;
  final Function(bool) onCartToggle;

  const ProductCard({
    required this.product,
    required this.onFavoriteToggle,
    required this.onCartToggle,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  bool isCart = false;

  // Hard-coded base URL (replace with your actual base URL)
  final String baseUrl = 'http://10.0.2.2:5001'; // <-- Replace with actual base URL
  late final WishlistAPI wishlistAPI;

  @override
  void initState() {
    super.initState();
    wishlistAPI = WishlistAPI(baseUrl: baseUrl); // Initialize with base URL
    print("Initialized ProductCard with product: ${widget.product}"); // Debug statement
  }

  void _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
      widget.onFavoriteToggle(isFavorite);
    });

    String itemID = widget.product['_id']; // Assuming the product map contains '_id'
    print("Toggling favorite for item ID: $itemID"); // Debug statement

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userID = prefs.getString('_id');

      if (userID == null) {
        Fluttertoast.showToast(
          msg: "User not logged in",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print("User ID is null, cannot toggle favorite."); // Debug statement
        return;
      }

      if (isFavorite) {
        await wishlistAPI.addItemToWishlist(userID, itemID);
        print('Added to wishlist for user: $userID'); // Debug statement
      } else {
        await wishlistAPI.removeItemFromWishlist(userID, itemID);
        print('Removed from wishlist for user: $userID'); // Debug statement
      }
    } catch (e) {
      print("Error updating wishlist: $e"); // Debug statement
    }
  }

  void _toggleCart() async {
    setState(() {
      isCart = !isCart;
      widget.onCartToggle(isCart);
    });

    String itemID = widget.product['_id']; // Get the product ID
    print("Toggling cart for item ID: $itemID"); // Debug statement

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userID = prefs.getString('_id');

      if (userID == null) {
        Fluttertoast.showToast(
          msg: "User not logged in",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print("User ID is null, cannot toggle cart."); // Debug statement
        return;
      }

      if (isCart) {
        await _addToCart(userID, itemID); // Call function to add to cart
        Fluttertoast.showToast(
          msg: "Added to cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        await _removeFromCart(userID, itemID); // Call function to remove from cart
        Fluttertoast.showToast(
          msg: "Removed from cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print("Error updating cart: $e"); // Debug statement
    }
  }

  Future<void> _addToCart(String userID, String itemID) async {
    // Implement your API call to add the item to the cart
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/cart/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userID': userID, 'itemID': itemID}),
      );

      if (response.statusCode == 200) {
        print('Item added to cart successfully. Response: ${response.body}'); // Debug statement
      } else {
        print('Failed to add item to cart. Status code: ${response.statusCode}'); // Debug statement
        throw Exception('Failed to add item to cart');
      }
    } catch (e) {
      print("Error adding item to cart: $e"); // Debug statement
    }
  }

  Future<void> _removeFromCart(String userID, String itemID) async {
    // Implement your API call to remove the item from the cart
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/remove'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userID': userID, 'itemID': itemID}),
      );

      if (response.statusCode == 200) {
        print('Item removed from cart successfully. Response: ${response.body}'); // Debug statement
      } else {
        print('Failed to remove item from cart. Status code: ${response.statusCode}'); // Debug statement
        throw Exception('Failed to remove item from cart');
      }
    } catch (e) {
      print("Error removing item from cart: $e"); // Debug statement
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 360.w,
          height: 190.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF591CAE), Colors.black],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 145.h,
                right: 50.w,
                child: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: isFavorite ? Colors.purple : Colors.white,
                    size: 26.sp,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ),
              Positioned(
                bottom: 145.h,
                right: 5.w,
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: isCart ? Colors.purple : Colors.white,
                    size: 26.sp,
                  ),
                  onPressed: _toggleCart,
                ),
              ),
              Positioned(
                top: 40.h,
                left: 10.w,
                right: 10.w,
                child: Container(
                  height: 150.h,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          widget.product['details'],
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            color: Colors.white,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Rs.${widget.product['price'].toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}