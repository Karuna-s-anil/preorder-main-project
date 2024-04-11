import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preorder/screen/user/cart_card.dart';

class ViewOrders extends StatefulWidget {
  const ViewOrders({super.key});

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isloading = false;
  Future Cooking(String bookingId) async {
    setState(() {
      _isloading = true;
    });
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('orders').doc(bookingId).update({
        'status': 'cooking',
      });
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        elevation: 1,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore.collection('orders').get(),
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
                return Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 220, 220, 220),
                  ),
                  height: 300,
                  width: double.infinity,
                  child:
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      CartCard(cart: data["items"]),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       data['foodName'],
                  //       style: const TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //     Text(
                  //       'Status: ${data['status']}',
                  //       style: const TextStyle(),
                  //     ),
                  //   ],
                  // ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     // Text('Amount: ${data['amount']}'),
                  //     data['status'] != 'cooking'
                  //         ? ElevatedButton(
                  //             // style: ElevatedButton.styleFrom(
                  //             //   minimumSize: const Size(30, 30),
                  //             // ),
                  //             onPressed: () async {
                  //               await Cooking(data['bookingId']);
                  //             },
                  //             child: _isloading
                  //                 ? const Center(
                  //                     child: CircularProgressIndicator(
                  //                       color: Colors.black,
                  //                     ),
                  //                   )
                  //                 : Text('Mark as Cooking'))
                  //         : Text('cooking'),
                  //   ],
                  // )
                  // ],
                  // ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
