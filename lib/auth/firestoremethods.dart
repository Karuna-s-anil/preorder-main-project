
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class fireStoreMethods {
  final FirebaseFirestore _firebasefirestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
}
