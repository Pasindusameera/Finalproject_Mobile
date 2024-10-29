import 'package:flutter/material.dart';
import 'package:sports/components/product_card.dart';
import 'package:sports/models/category.dart';
import 'package:sports/models/product.dart';
import 'package:sports/widgets/widget_home_categories.dart';

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key:key);

  

  @override
  Widget build(BuildContext context) {
    
    // ignore: unused_local_variable
    Product model = Product(
    productName: "Volleyball", 
    category: Category(
      categoryName:"Equipment" , 
      fullImagePath: "/uploads/volleyball.png"), 
    productDescription: "Score big with this high-quality volleyball! Engineered for durability and precision, this volleyball is perfect for both indoor and outdoor games. Its soft-touch surface ensures better grip and control, ideal for players of all skill levels. Whether you're spiking on the beach or serving indoors, this volleyball is designed to deliver top performance. Get yours today and elevate your game!", 
    productPrice:4200 , 
    productImage: "/uploads/volleyball.png", 
    productId: "1",
    );
    return Scaffold(
      body:Container(
        child:ListView(children: const [
          HomeCategoriesWidget(),
          ProductCard(),
        ],

        ) ,
      ) ,

    );
  }
}