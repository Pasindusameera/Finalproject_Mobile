// features/customer_screens/shop/shop_cartlist.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyCartList extends StatefulWidget {
  final String userID;

  const MyCartList(this.userID, {super.key});

  @override
  State<MyCartList> createState() => _MyCartListState();
}

class _MyCartListState extends State<MyCartList> {
  List<Map<String, dynamic>> cartList = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    try {
      // Correct the endpoint URL
      final response = await http.get(Uri.parse('http://10.0.2.2:5001/api/cart/${widget.userID}'));
      print("Fetching cart items for user: ${widget.userID}"); // Debug statement

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Cart items fetched successfully: $data"); // Debug statement

        setState(() {
          cartList = (data['items'] as List).map((item) {
            return {
              'id': item['itemID']['_id'],
              'name': item['itemID']['name'],
              'price': item['itemID']['price'],
              'quantity': item['quantity'],
            };
          }).toList();
        });
      } else {
        print('Failed to load cart items. Status code: ${response.statusCode}'); // Debug statement
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      print('Error fetching cart items: $e'); // Debug statement
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cart items. Please try again.')),
      );
    }
  }

  Future<void> _addItemToCart(String itemID, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/api/cart/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userID': widget.userID, 'itemID': itemID, 'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        print('Item added to cart successfully. Response: ${response.body}'); // Debug statement
        _fetchCartItems(); // Refresh cart items after adding
      } else {
        print('Failed to add item to cart. Status code: ${response.statusCode}'); // Debug statement
        throw Exception('Failed to add item to cart');
      }
    } catch (e) {
      print('Error adding item to cart: $e'); // Debug statement
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item to cart.')),
      );
    }
  }

  Future<void> _removeItemFromCart(String itemID) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5001/api/cart/remove'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userID': widget.userID, 'itemID': itemID}),
      );

      if (response.statusCode == 200) {
        print('Item removed from cart successfully. Response: ${response.body}'); // Debug statement
        _fetchCartItems(); // Refresh cart items after removal
      } else {
        print('Failed to remove item from cart. Status code: ${response.statusCode}'); // Debug statement
        throw Exception('Failed to remove item from cart');
      }
    } catch (e) {
      print('Error removing item from cart: $e'); // Debug statement
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item from cart.')),
      );
    }
  }

  Future<void> _updateItemQuantity(String itemID, int quantity) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5001/api/cart/update'), // Ensure this endpoint is correct
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userID': widget.userID, 'itemID': itemID, 'quantity': quantity}),
      );

      if (response.statusCode != 200) {
        print('Failed to update item quantity. Status code: ${response.statusCode}'); // Debug statement
        throw Exception('Failed to update item quantity');
      }
    } catch (e) {
      print('Error updating item quantity: $e'); // Debug statement
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update item quantity.')),
      );
    }
  }

  void _incrementQuantity(int index) {
    setState(() {
      cartList[index]['quantity'] += 1;
      _updateItemQuantity(cartList[index]['id'], cartList[index]['quantity']);
    });
    print("Incremented quantity for item ID: ${cartList[index]['id']} to ${cartList[index]['quantity']}"); // Debug statement
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (cartList[index]['quantity'] > 1) {
        cartList[index]['quantity'] -= 1;
        _updateItemQuantity(cartList[index]['id'], cartList[index]['quantity']);
      }
    });
    print("Decremented quantity for item ID: ${cartList[index]['id']} to ${cartList[index]['quantity']}"); // Debug statement
  }

  double _calculateTotalPrice() {
    return cartList.fold(0.0, (total, item) => total + (item['price'] * item['quantity']));
  }

  int _calculateTotalItems() {
    return cartList.fold<int>(0, (total, item) => total + (item['quantity'] as int));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF591CAE),
        title: Text(
          'Cart',
          style: TextStyle(fontSize: 22.sp, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                final item = cartList[index];
                return Padding(
                  padding: EdgeInsets.only(top: 30.0.h, left: 15.w, right: 15.w),
                  child: Container(
                    height: 170.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF591CAE), Colors.black],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20.sp),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Unit Price: Rs.${item['price']}',
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Total: Rs.${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25.0.h, right: 10.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: Colors.white),
                                    onPressed: () => _decrementQuantity(index),
                                  ),
                                  Text(
                                    item['quantity'].toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.white),
                                    onPressed: () => _incrementQuantity(index),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: () => _removeItemFromCart(item['id']),
                                child: Container(
                                  width: 80.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF591CAE),
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Remove",
                                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: 250.w,
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
              gradient: const LinearGradient(
                colors: [Color(0xFF591CAE), Colors.black],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            padding: EdgeInsets.all(10.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Total Items:',
                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '${_calculateTotalItems()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Total Price: ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Rs.${_calculateTotalPrice().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Implement the action to place the order
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Place Order',
                      style: TextStyle(color: Colors.black, fontSize: 18.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}