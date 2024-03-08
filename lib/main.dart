// ignore_for_file: prefer_const_constructors

import 'package:preorder/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:preorder/auth/user_provider.dart';
import 'package:preorder/indexPage.dart';
import 'package:preorder/screen/login_screen.dart';
import 'package:preorder/auth/auth_methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.light,
      textTheme: GoogleFonts.latoTextTheme(),
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: 'Perorder',
        home: UserAuth(),
      ),
    );
  }
}

class UserAuth extends StatelessWidget {
  const UserAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationProvider>(context);

    if (auth.isAuthenticated) {
      return Consumer<UserProvider>(builder: (context, userProvider, child) {
        if (userProvider.userModel == null) {
          // load the user data and update the provider
          final authmeth = authmethods();
          authmeth.getuserdetails().then((userModel) {
            userProvider.setUserModel(userModel);
          });
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return IndexPage();
      });
    } else {
      return loginscreen();
    }
  }
}
