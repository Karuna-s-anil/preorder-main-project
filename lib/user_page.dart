// ignore_for_file: prefer_const_constructors, body_might_complete_normally_nullable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:preorder/screen/user/book_parking.dart';
import 'package:preorder/screen/user/orders_and_bookings.dart';
import 'package:preorder/screen/user/view_foods.dart';

class UserIndexPage extends StatefulWidget {
  const UserIndexPage({super.key});

  @override
  State<UserIndexPage> createState() => _AdmiIndexnPageState();
}

class _AdmiIndexnPageState extends State<UserIndexPage> {
  int index = 0;
  List<dynamic> tabs = [
    FoodExplore(),
    ParkingBookingPage(),
    OrdersAndBookings(),
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
                print(index);
              });
            },
            padding: EdgeInsets.all(16),
            tabs: [
              GButton(icon: Icons.food_bank, text: 'Foods'),
              GButton(icon: Icons.car_crash, text: 'Parking'),
              GButton(icon: Icons.food_bank, text: 'Bookings'),
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
