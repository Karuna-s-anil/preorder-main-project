import 'package:flutter/material.dart';
import 'package:preorder/screen/security/qr_scanner.dart';
import 'package:preorder/screen/security/view_parking.dart';

class SecurityHomePage extends StatefulWidget {
  const SecurityHomePage({super.key});

  @override
  State<SecurityHomePage> createState() => _SecurityHomePageState();
}

class _SecurityHomePageState extends State<SecurityHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SecurityQRScanner(),
            ),
          );
        },
        child: const Icon(
          Icons.qr_code_scanner,
        ),
      ),
      body: ParkingBookingPage(),
    );
  }
}
