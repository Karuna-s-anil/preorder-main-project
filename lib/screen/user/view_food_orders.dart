import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preorder/auth/user_provider.dart';
import 'package:preorder/screen/shop/cart_card.dart';
import 'package:preorder/screen/user/food_tickets.dart';
import 'package:preorder/screen/user/orders_card.dart';
import 'package:provider/provider.dart';

class ViewFoodOrders extends StatelessWidget {
  const ViewFoodOrders({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
        ),
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('orders')
              .where('uId', isEqualTo: userModel!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<DocumentSnapshot> securityDocs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: securityDocs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      securityDocs[index].data() as Map<String, dynamic>;
                  print("data['status']");
                  print("data['status']");
                  print(data['status']);
                  return Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 220, 220, 220),
                    ),
                    height: 300,
                    width: double.infinity,
                    child: OrdersFoodCard(
                        status: data["status"], cart: data["items"]),
                  );
                },
              );
            }
          },
        ));
  }
}
