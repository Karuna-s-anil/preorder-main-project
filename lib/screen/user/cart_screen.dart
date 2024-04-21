import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:preorder/screen/user/cart_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  Future orderFood(List<dynamic> items) async {
    String BookingId = const Uuid().v1();
    await firestore.collection('orders').doc(BookingId).set({'set': '1'});
    try {
      await firestore.collection('orders').doc(BookingId).set({
        'bookingId': BookingId,
        'uId': user.uid,
        'time': DateTime.now(),
        'items': items,
        'status': 'ordered',
      });
    } catch (e) {
      print(e.toString());
    }

    // try {
    //   await firestore.collection('foods').doc(widget.postId).update({
    //     'orders': FieldValue.arrayUnion([BookingId])
    //   });
    // } catch (e) {
    //   print(e.toString());
    // }
    try {
      await firestore.collection('users').doc(user.uid).update({
        'orders': FieldValue.arrayUnion([BookingId])
      });
    } catch (e) {
      print(e.toString());
    }

    await firestore.collection('cart').doc(user.uid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Your Cart",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cart')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(
                child: Text('No items in the cart.'),
              );
            }

            var cartData = snapshot.data!.data() as Map<String, dynamic>;

            double totalAmount = 0;
            if (cartData["items"] != null) {
              for (var item in cartData["items"]) {
                totalAmount += item["amount"] * item["count"];
              }
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartData["items"].length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CartCard(cart: cartData["items"]),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, -15),
                          blurRadius: 20,
                          color: Color(0xFFDADADA).withOpacity(0.15),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Total:\n",
                            children: [
                              TextSpan(
                                text: "\₹${totalAmount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 190,
                          child: ElevatedButton(
                            child: Text("Check Out"),
                            onPressed: () async {
                              await orderFood(cartData['items']);
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
