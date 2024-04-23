// ignore_for_file: prefer_const_constructors

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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

  Future<void> _bookParkingSlot(int selectedHour) async {
    final DateTime today = DateTime.now();
    final String todayDate = "${today.year}-${today.month}-${today.day}";

    DocumentSnapshot bookingDoc =
        await _firestore.collection('bookings').doc(todayDate).get();

    int maxSlots = bookingDoc['maxSlots'];
    List<Map<String, dynamic>> bookingsList = List.from(bookingDoc['bookings']);
    List<Map<String, dynamic>> hourlySlotsList =
        List.from(bookingDoc['hourlySlots']);
    if (hourlySlotsList.any(
      (slot) => slot['hour'] == selectedHour && slot['slots'] > 0,
    )) {
      bookingsList.remove({
        'bookingId': docID,
      });

      try {
        _firestore.collection('users').doc(user.uid).update({
          'bookings': FieldValue.arrayRemove([docID])
        });
      } catch (e) {
        print(e.toString());
      }

      int hourlySlotsIndex =
          hourlySlotsList.indexWhere((slot) => slot['hour'] == selectedHour);

      hourlySlotsList[hourlySlotsIndex]['slots'] += 1;

      await _firestore.collection('bookings').doc(todayDate).update({
        'maxSlots': maxSlots,
        'bookings': bookingsList,
        'hourlySlots': hourlySlotsList,
      });
    } else {
      print('No available slots');
    }
  }

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
          return GestureDetector(
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
                                  Text(
                                      'Time: ${booking['hour'].toString()}:00 - ${booking['hour'] + 1}:00'),
                                  Text(formatFirebaseTimestamp(
                                      booking['bookingTime'])),
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
                          ElevatedButton(
                            onPressed: () async {
                              await _bookParkingSlot(booking['hour']);
                              await users.doc(docID).delete().then((value) {
                                print('Document deleted successfully');
                                final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Yay🚗',
                                    message: 'Cancellation successful',
                                    contentType: ContentType.success,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              }).catchError((error) {
                                print('Failed to delete document: $error');
                              });
                            },
                            child: Text("cancel"),
                          )
                        ],
                      ),
                    ),
                  ],
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
