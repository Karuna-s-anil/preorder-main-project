import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ParkingBookingPage extends StatefulWidget {
  const ParkingBookingPage({super.key});

  @override
  State<ParkingBookingPage> createState() => _ParkingBookingPageState();
}

class _ParkingBookingPageState extends State<ParkingBookingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  int maxSlots = 0;

  @override
  void initState() {
    checkHour();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Booking Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Display available slots
          StreamBuilder(
            stream: _firestore
                .collection('bookings')
                .doc(_getTodayDate())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text('Loading...');
              }

              maxSlots = snapshot.data!['maxSlots'];
              return Text('Slots left: $maxSlots');
            },
          ),
          FutureBuilder(
            future:
                _firestore.collection('bookings').doc(_getTodayDate()).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              // List<Map<String, dynamic>> bookingsList =
              //     List<Map<String, dynamic>>.from(
              //   (snapshot.data?.get('bookings') as List) ?? [],
              // );
              int currentHour = DateTime.now().hour;

              List<Map<String, dynamic>> hourlySlotsList =
                  List<Map<String, dynamic>>.from(
                (snapshot.data?.get('hourlySlots') as List),
              );
              // int currentHour = DateTime.now().hour;

              return Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 24 - currentHour,
                  itemBuilder: (context, index) {
                    int hour = currentHour + index;
                    bool isHourAvailable = hourlySlotsList.any(
                      (slot) => slot['hour'] == hour && slot['slots'] > 0,
                    );

                    print(isHourAvailable);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: isHourAvailable
                            ? () async {
                                await _bookParkingSlot(hour);
                              }
                            : null,
                        child: Text(
                          '$hour:00',
                          style: TextStyle(
                            color: isHourAvailable ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> checkHour() async {
    final DateTime today = DateTime.now();
    final String todayDate = "${today.year}-${today.month}-${today.day}";
    DocumentSnapshot bookingDoc =
        await _firestore.collection('bookings').doc(todayDate).get();
    if (!bookingDoc.exists) {
      List<Map<String, dynamic>> hourlySlotsList = List.generate(
        24,
        (index) => {'hour': index, 'slots': 20},
      );

      await _firestore.collection('bookings').doc(todayDate).set({
        'maxSlots': 20,
        'bookings': [],
        'hourlySlots': hourlySlotsList,
      });
      bookingDoc = await _firestore.collection('bookings').doc(todayDate).get();
    }
  }

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
      String bookingId = const Uuid().v1();

      bookingsList.add({
        'bookingId': bookingId,
        'hour': selectedHour,
        'userId': user.uid,
        'bookingTime': DateTime.now(),
        'status': 'upcoming',
      });

      try {
        _firestore.collection('users').doc(user.uid).update({
          'bookings': FieldValue.arrayUnion([bookingId])
        });
      } catch (e) {
        print(e.toString());
      }

      try {
        await _firestore.collection('bookings').doc(bookingId).set({
          'bookingId': bookingId,
          'uId': user.uid,
          'bookingTime': DateTime.now(),
          'hour': selectedHour,
          'status': 'upcoming',
        });
      } catch (e) {
        print(e.toString());
      }

      int hourlySlotsIndex =
          hourlySlotsList.indexWhere((slot) => slot['hour'] == selectedHour);

      hourlySlotsList[hourlySlotsIndex]['slots'] -= 1;

      await _firestore.collection('bookings').doc(todayDate).update({
        'maxSlots': maxSlots,
        'bookings': bookingsList,
        'hourlySlots': hourlySlotsList,
      });

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Yay🚗',
          message: 'Booking successful',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      print('No available slots');
    }
  }

  String _getTodayDate() {
    final DateTime today = DateTime.now();
    return "${today.year}-${today.month}-${today.day}";
  }
}
