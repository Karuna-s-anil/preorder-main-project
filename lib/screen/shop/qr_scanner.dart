import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({
    super.key,
  });
  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final user = FirebaseAuth.instance.currentUser!;
  Barcode? result;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var name = '';
  var date = '';

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  String formatDateRange(String startDate, String endDate) {
    print(startDate);
    print(endDate);
    final startDateTime = DateTime.parse(startDate);
    print(startDateTime);
    final endDateTime = DateTime.parse(endDate);

    final startFormatted = DateFormat.MMMMd().format(startDateTime);
    final endFormatted = DateFormat.MMMMd().format(endDateTime);

    return '$startFormatted to $endFormatted';
  }

  void getUsername() async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(result!.code)
          .get()
          .then((Bvalue) async {
        print("Bvalue.data()");
        print(Bvalue.data());
        print("Bvalue.data()");
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(result!.code)
            .update({'status': 'order delivered'});
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (result != null) {
      print("${result!.code}is not null. starting username fetch.");
      getUsername();
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderWidth: 10,
                borderColor: const Color.fromARGB(255, 75, 167, 241),
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (name != '')
                  ? Column(
                      children: [
                        Text('$name checked in 🥳'),
                        Text(date),
                      ],
                    )
                  : const Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }
}
