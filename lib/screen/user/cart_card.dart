import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_button/counter_button.dart';
import 'package:flutter_svg/svg.dart';

class CartCard extends StatelessWidget {
  const CartCard({Key? key, required this.cart});

  final List<dynamic> cart;

  Future<void> _updateItemCount(int index, int newCount) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference cartDocRef =
          FirebaseFirestore.instance.collection("cart").doc(uid);
      DocumentSnapshot cartDoc = await cartDocRef.get();
      if (cartDoc.exists) {
        List<dynamic> items = cartDoc["items"];
        Map<String, dynamic>? itemToUpdate;
        for (var item in items) {
          if (item["foodId"] == cart[index]["foodId"]) {
            itemToUpdate = item;
            break;
          }
        }
        if (itemToUpdate != null) {
          itemToUpdate["count"] = newCount;
          await cartDocRef.update({"items": items});
        }
      }
    } catch (error) {
      print("Error updating item count: $error");
    }
  }

  Future<void> _removeItemFromCart(String foodId) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference cartDocRef =
          FirebaseFirestore.instance.collection("cart").doc(uid);
      DocumentSnapshot cartDoc = await cartDocRef.get();

      if (cartDoc.exists) {
        List<dynamic> items = List.from(cartDoc["items"]);

        int indexToRemove = -1;
        for (int i = 0; i < items.length; i++) {
          if (items[i]["foodId"] == foodId) {
            indexToRemove = i;
            break;
          }
        }

        if (indexToRemove != -1) {
          items.removeAt(indexToRemove);
          await cartDocRef.update({"items": items});
        }
      }
    } catch (error) {
      print("Error removing item from cart: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(cart[index]["foodId"]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await _removeItemFromCart(cart[index]["foodId"]);
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),
                  SvgPicture.asset("assets/Trash.svg"),
                ],
              ),
            ),
            child: Row(
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
                    SizedBox(
                      width: 200,
                      child: Text(
                        cart[index]["foodName"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "\₹${cart[index]["amount"]}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue),
                          ),
                        ),
                        SizedBox(width: 10),
                        CounterButton(
                          loading: false,
                          onChange: (int val) async {
                            await _updateItemCount(index, val);
                          },
                          count: cart[index]["count"],
                          countColor: Colors.black,
                          buttonColor: Colors.black,
                          progressColor: Colors.black,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
