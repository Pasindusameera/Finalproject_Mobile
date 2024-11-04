// features/customer_screens/shop/shop_home.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playhub/features/customer_screens/shop/components/product_card.dart';
import 'package:playhub/features/customer_screens/shop/shop_cartlist.dart';
import 'package:playhub/features/customer_screens/shop/shop_wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> wishlistItems = [];
  final List<Map<String, dynamic>> cartList = [];
  List<dynamic> shopItems = []; // List to store shop items
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    fetchShopItems();
    _getCurrentUserId();
  }

Future<void> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('_id'); // Retrieve user ID using the correct key
    });
    print("Current User ID: $currentUserId"); // Debug print
  }
  
  Future<void> fetchShopItems() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5001/items'));
      if (response.statusCode == 200) {
        setState(() {
          shopItems = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print("Error fetching shop items: $e");
    }
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      if (!cartList.any((cartItem) => cartItem['name'] == item['name'])) {
        cartList.add(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item['name']} added to cart!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item['name']} is already in the cart.')),
        );
      }
    });
  }

  void _removeFromCart(Map<String, dynamic> item) {
    setState(() {
      cartList.removeWhere((cartItem) => cartItem['name'] == item['name']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item['name']} removed from cart!')),
      );
    });
  }

  void _addToWishlist(Map<String, dynamic> item) {
    setState(() {
      wishlistItems.add(item);
    });
  }

  void _removeFromWishlist(Map<String, dynamic> item) {
    setState(() {
      wishlistItems.removeWhere((element) => element['name'] == item['name']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF591CAE),
        title: Text(
          'Shop',
          style: TextStyle(
            fontSize: 24.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white, size: 24.sp),
            onPressed: () {
              Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => MyCartList(currentUserId!)), // Pass a valid userID string here
);
            },

            
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white, size: 24.sp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyShopWishList(_addToCart)),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                _buildSearchBar(),
                _buildFeaturedItems(),
                _buildBrandSection(),
                _buildNewArrivals(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(25.0.r),
      child: Container(
        width: 400.0.w,
        height: 50.0.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0.r),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0.w),
              child: Icon(Icons.search, color: Colors.black, size: 30.0.sp),
            ),
            SizedBox(width: 25.w),
            Expanded(
              child: Text(
                "What are you looking for?",
                style: GoogleFonts.poppins(fontSize: 16.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedItems() {
    return SizedBox(
      height: 200.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Container(
              width: 400.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF591CAE), Colors.black],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(12.sp),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 8.0.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0.w, top: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Football",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Discount 50%",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                // Action for 'Shop Now'
                              },
                              child: Container(
                                width: 170.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: Color(0xFF591CAE),
                                  borderRadius: BorderRadius.circular(24.sp),
                                ),
                                child: Center(
                                  child: Text(
                                    'Shop Now',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Image.asset(
                        'assets/images/football.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 18.0.w, right: 18.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Brand',
                style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'See all',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.sp),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 10.w),
              ...['nike.png', 'addidas.png', 'reebok.png'].map((brandImage) {
                return Padding(
                  padding: EdgeInsets.only(right: 25.w),
                  child: CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/$brandImage',
                        width: 100.w,
                        height: 100.h,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewArrivals() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 230.0.w),
          child: Text(
            'New Arrival',
            style: GoogleFonts.poppins(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: Row(
              children: List.generate(shopItems.length, (index) {
                final product = shopItems[index];

                return Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: ProductCard(
                    product: product,
                    onCartToggle: (isCart) {
                      setState(() {
                        if (isCart) {
                          _addToCart(product);
                        } else {
                          _removeFromCart(product);
                        }
                      });
                    },
                    onFavoriteToggle: (isFavorite) {
                      setState(() {
                        if (isFavorite) {
                          _addToWishlist(product);
                        } else {
                          _removeFromWishlist(product);
                        }
                      });
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}