import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:preorder/models/models.dart' as model;

class AuthenticationProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? _user;

  AuthenticationProvider() {
    auth.authStateChanges().listen((user) {
      _user = user;

      notifyListeners();
    });
  }
  bool get isAuthenticated => _user != null;
}

class UserProvider extends ChangeNotifier {
  model.UserModel? _userModel;

  model.UserModel? get userModel => _userModel;

  void setUserModel(model.UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }
}
