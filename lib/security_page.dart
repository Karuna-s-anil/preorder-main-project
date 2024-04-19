// ignore_for_file: prefer_const_constructors, body_might_complete_normally_nullable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:preorder/screen/security/security_homepage.dart';

class SecurityIndexPage extends StatefulWidget {
  const SecurityIndexPage({super.key});

  @override
  State<SecurityIndexPage> createState() => _AdmiIndexnPageState();
}

class _AdmiIndexnPageState extends State<SecurityIndexPage> {
  int index = 0;
  List<dynamic> tabs = [
    SecurityHomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: tabs[index],
      ),
    );
  }
}
