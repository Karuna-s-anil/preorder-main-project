// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:preorder/screen/shop/add_food.dart';
import 'package:preorder/screen/shop/view_orders.dart';
import 'package:preorder/screen/shop/view_foods.dart';
import 'package:preorder/screen/shop/view_security.dart';

class ShopOwnerIndexPage extends StatefulWidget {
  const ShopOwnerIndexPage({super.key});

  @override
  State<ShopOwnerIndexPage> createState() => _AdmiIndexnPageState();
}

class _AdmiIndexnPageState extends State<ShopOwnerIndexPage> {
  int index = 0;
  List<dynamic> tabs = [
    ViewFoodsShopOwner(),
    ViewOrders(),
    AddFood(),
    ViewSecurity(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey,
            gap: 8,
            onTabChange: (value) {
              setState(() {
                index = value;
              });
            },
            padding: EdgeInsets.all(16),
            tabs: const [
              GButton(icon: Icons.food_bank, text: 'My Foods'),
              GButton(
                icon: Icons.list_alt,
                text: 'Orders',
              ),
              GButton(icon: Icons.add, text: 'Add Item'),
              GButton(icon: Icons.security, text: 'My Security'),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: tabs[index],
      ),
    );
  }
}
