import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preorder/auth/user_provider.dart';
import 'package:preorder/screen/user/parking_tickets.dart';
import 'package:provider/provider.dart';

class ViewParkingBookings extends StatelessWidget {
  const ViewParkingBookings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking'),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('bookings')
            .where('uId', isEqualTo: userModel!.uid)
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No orders found.'),
            );
          } else {
            final bookings = snapshot.data!.docs;

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (BuildContext context, int index) {
                final booking = bookings[index].data();
                print("bookings");
                print(booking);
                print("bookings");
                return ParkingTicket(
                  docID: booking['bookingId'],
                  booking: booking,
                );
              },
            );
          }
        },
      ),
    );
  }
}
