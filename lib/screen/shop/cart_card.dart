import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartCard extends StatelessWidget {
  const CartCard({Key? key, required this.cart, required this.uId});

  final List<dynamic> cart;
  final String uId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("users").doc(uId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          final userName = snapshot.data!["username"];
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Text(
                    "User: $userName",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          SizedBox(
                            width: 88,
                            child: AspectRatio(
                              aspectRatio: 0.88,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F6F9),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image.network(cart[index]["imageUrl"]),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cart[index]["foodName"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                maxLines: 2,
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: "\₹${cart[index]["amount"]}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text.rich(
                                    TextSpan(
                                      text: "count: ${cart[index]["count"]}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
