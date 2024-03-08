// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_button/counter_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails({
    super.key,
    required this.imageUrl,
    required this.foodName,
    required this.postId,
  });
  final String imageUrl;
  final String foodName;
  final String postId;

  @override
  State<FoodDetails> createState() => _FoodStateDetails();
}

class _FoodStateDetails extends State<FoodDetails> {
  int foodcount = 1;
  int _counterValue = 1;
  final bool _isloading = false;

  Future orderFood() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    String BookingId = const Uuid().v1();
    await firestore.collection('orders').doc(BookingId).set({'set': ''});
    try {
      await firestore.collection('orders').doc(BookingId).set({
        'bookingId': BookingId,
        'uId': user.uid,
        'amount': _counterValue,
        'time': DateTime.now(),
        'foodName': widget.foodName,
        'foodId': widget.postId,
        'status': 'ordered',
      });
    } catch (e) {
      print(e.toString());
    }

    try {
      firestore.collection('foods').doc(widget.postId).update({
        'orders': FieldValue.arrayUnion([BookingId])
      });
    } catch (e) {
      print(e.toString());
    }
    try {
      firestore.collection('users').doc(user.uid).update({
        'orders': FieldValue.arrayUnion([BookingId])
      });
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CounterButton(
              loading: false,
              onChange: (int val) {
                setState(() {
                  _counterValue = val;
                });
              },
              count: _counterValue,
              countColor: Colors.black,
              buttonColor: Colors.black,
              progressColor: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: width * 0.6,
                height: width * 0.15,
                child: GestureDetector(
                  onTap: () async {
                    await orderFood();
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Yay',
                        message: 'Food Booked',
                        contentType: ContentType.success,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: _isloading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Book food',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
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
