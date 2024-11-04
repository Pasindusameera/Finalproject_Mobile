// features/customer_screens/shop/shop_wishlist.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playhub/core/api/wishlist_api.dart';

class MyShopWishList extends StatefulWidget {
  final Function(Map<String, dynamic>) addToCart;

  const MyShopWishList(this.addToCart, {super.key});

  @override
  State<MyShopWishList> createState() => _MyShopWishListState();
}

class _MyShopWishListState extends State<MyShopWishList> {
  List<Map<String, dynamic>> wishlistItems = [];
  final WishlistAPI wishlistAPI =
      WishlistAPI(baseUrl: 'http://10.0.2.2:5001/api/wishlist');

  @override
  void initState() {
    super.initState();
    _fetchWishlistItems();
  }

  Future<void> _fetchWishlistItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userID = prefs.getString('_id');

      if (userID != null) {
        List<dynamic> items = await wishlistAPI.getWishlistItems(userID);
        setState(() {
          wishlistItems = items.cast<Map<String, dynamic>>();
        });
      } else {
        print("No user ID found. Please log in.");
      }
    } catch (e) {
      print("Failed to fetch wishlist items: $e");
    }
  }

void _removeItem(int index) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final String? userID = prefs.getString('_id');

    if (userID != null) {
      // Assuming your wishlistItems structure has the ObjectId as '_id'
      String itemID = wishlistItems[index]['_id'].toString(); // Convert ObjectId to String if necessary
      print("Removing item with ID: $itemID for user: $userID");
      
      await wishlistAPI.removeItemFromWishlist(userID, itemID);
      
      setState(() {
        wishlistItems.removeAt(index);
      });

      // Show a Snackbar for feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item removed from wishlist')),
      );
    } else {
      print("No user ID found. Please log in.");
    }
  } catch (e) {
    print("Failed to remove item from wishlist: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF591CAE),
        title: Text(
          'Favorites',
          style: TextStyle(
            fontSize: 24.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: wishlistItems.isEmpty
          ? Center(
              child: Text(
                'No items in your wishlist',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
            )
          : ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return Padding(
                  padding:
                      EdgeInsets.only(top: 30.0.h, left: 20.w, right: 20.w),
                  child: Container(
                    height: 280.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF591CAE), Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0.w, vertical: 20.h),
                          child: Text(
                            item['name'],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['details'],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'Rs.${item['price'].toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.purple,
                                  size: 24.sp,
                                ),
                                onPressed: () {
                                  print(
                                      'Remove button pressed for item: ${item['name']}');
                                  _removeItem(index);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                  size: 24.sp,
                                ),
                                onPressed: () {
                                  widget.addToCart(item);
                                  _removeItem(index);
                                },
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
    );
  }
}
