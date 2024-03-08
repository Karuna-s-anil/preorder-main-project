import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:preorder/models/models.dart' as model;
import 'package:preorder/auth/storage_methods.dart';

class authmethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<model.UserModel> getuserdetails() async {
    User currentuser = auth.currentUser!;
    DocumentSnapshot snap =
        await firestore.collection('users').doc(currentuser.uid).get();
    return model.UserModel.fromsnap(snap);
  }

  Future<String> signupuser({
    required String username,
    required String email,
    required String phone,
    required String password,
    required String type,
    required Uint8List file,
  }) async {
    String res = 'errror occured';
    try {
      print('2');
      print(username);
      print(email);
      print("phone");

      print(password);

      if (username.isNotEmpty ||
          email.isNotEmpty ||
          phone.isNotEmpty ||
          password.isNotEmpty) {
        print('3');
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photourl = await StorageMethods()
            .uploadImageStorage('profilepics', file, false);

        model.UserModel user = model.UserModel(
            mail: email,
            uid: cred.user!.uid,
            phone: phone,
            type: type,
            username: username,
            photourl: photourl);
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = 'succes';
        print(res);
      } else {
        print('NUll value');
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        print('invalidemail');
      } else {
        print("hiiioi");
        print(error.code);
      }
    } catch (e) {
      print(e);
      res = e.toString();
    }
    print("inside function");
    print(res);
    return res;
  }

  Future<String> loginuser({
    required String email,
    required String password,
  }) async {
    String res = 'some errror occured';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'succes';
      } else {}
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
      } else {
        print(error.code);
      }
    } catch (e) {
      print(e);
      res = "e.toString()";
    }

    return res;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
