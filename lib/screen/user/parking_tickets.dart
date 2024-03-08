// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class ParkingTicket extends StatelessWidget {
  ParkingTicket({super.key, required this.docID, required this.booking});

  final String docID;
  final Map<String, dynamic> booking;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = _firestore.collection('bookings');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(docID).get(),
      builder: (((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          // Map<String, dynamic> snap =
          //     snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 235, 230, 229),
                          borderRadius: BorderRadius.all(
                            Radius.circular(21),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(snap['food']),
                                    Text(booking['hour'].toString()),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.green,
                                  child: Text(booking['status']),
                                ),
                                booking['status'] != 'completed'
                                    ? QrImageView(
                                        data: booking['bookingId'],
                                        version: QrVersions.auto,
                                        size: 100.0,
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      })),
    );
  }

  String formatFirebaseTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    final dateFormat = DateFormat('d-MMM-y h:mm a');
    String formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }
}
