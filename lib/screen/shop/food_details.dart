// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_button/counter_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ShopFoodDetails extends StatefulWidget {
  const ShopFoodDetails({
    super.key,
    required this.imageUrl,
    required this.foodName,
    required this.postId,
    required this.description,
    required this.price,
  });
  final String imageUrl;
  final String foodName;
  final String postId;
  final String description;
  final int price;

  @override
  State<ShopFoodDetails> createState() => _FoodStateDetails();
}

class _FoodStateDetails extends State<ShopFoodDetails> {
  int foodcount = 1;
  int _counterValue = 1;
  final bool _isloading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  Future orderFood() async {
    String BookingId = const Uuid().v1();
    await firestore.collection('orders').doc(BookingId).set({'set': '1'});
    try {
      await firestore.collection('orders').doc(BookingId).set({
        'bookingId': BookingId,
        'uId': user.uid,
        'time': DateTime.now(),
        'items': [
          {
            'amount': widget.price,
            'count': _counterValue,
            'time': DateTime.now(),
            'foodName': widget.foodName,
            'imageUrl': widget.imageUrl,
            'foodId': widget.postId,
          }
        ],
        'status': 'ordered',
      });
    } catch (e) {
      print(e.toString());
    }

    try {
      await firestore.collection('foods').doc(widget.postId).update({
        'orders': FieldValue.arrayUnion([BookingId])
      });
    } catch (e) {
      print(e.toString());
    }
    try {
      await firestore.collection('users').doc(user.uid).update({
        'orders': FieldValue.arrayUnion([BookingId])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future addToCart() async {
    try {
      DocumentReference<Map<String, dynamic>> cartDoc =
          firestore.collection('cart').doc(user.uid);
      DocumentSnapshot<Map<String, dynamic>> cartDocSnapshot =
          await cartDoc.get();
      if (!cartDocSnapshot.exists) {
        print("Not exists");
        await firestore.collection('cart').doc(user.uid).set({'set': '1'});
        cartDocSnapshot = await cartDoc.get();
      }
      if (cartDocSnapshot.exists) {
        print("exists");

        await cartDoc.update({
          'items': FieldValue.arrayUnion([
            {
              'amount': widget.price,
              'count': _counterValue,
              'time': DateTime.now(),
              'foodName': widget.foodName,
              'imageUrl': widget.imageUrl,
              'foodId': widget.postId,
            }
          ])
        });
      } else {
        await cartDoc.set({
          'items': [
            {
              'amount': widget.price,
              'count': _counterValue,
              'time': DateTime.now(),
              'imageUrl': widget.imageUrl,
              'foodName': widget.foodName,
              'foodId': widget.postId,
            }
          ]
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFA0A5BD), Color(0xFFB9B8C8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.53,
                      width: width,
                      child: Image.network(
                        fit: BoxFit.cover,
                        widget.imageUrl,
                      ),
                    ),
                  ],
                )),
            Positioned(
              top: height * 0.5,
              child: SizedBox(
                height: height * 0.5,
                width: width,
                child: Container(
                  width: 180,
                  height: 130,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Color.fromARGB(255, 222, 221, 228),
                        Color.fromARGB(195, 230, 227, 230)
                      ])),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(218, 241, 241, 241)),
                        width: width * 0.7,
                        height: height * 0.08,
                        child: Center(
                          child: Text(
                            widget.foodName,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '₹ ${widget.price * _counterValue}',
                        style: TextStyle(
                          fontSize: 20,
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
    );
  }
}
