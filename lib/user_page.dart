// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class UserIndexPage extends StatefulWidget {
  const UserIndexPage({super.key});

  @override
  State<UserIndexPage> createState() => _AdmiIndexnPageState();
}

class _AdmiIndexnPageState extends State<UserIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('User Index Page')));
  }
}
