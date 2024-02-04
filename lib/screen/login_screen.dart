import 'package:flutter/material.dart';
import 'package:preorder/auth/auth_methods.dart';
import 'package:preorder/indexPage.dart';
import 'package:preorder/main.dart';
import 'package:preorder/screen/signup_screen.dart';
import 'package:preorder/utils/utils.dart';

class loginscreen extends StatefulWidget {
  const loginscreen({super.key});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool _isloading = false;
  void navigatetosingnup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const signupscreen(),
      ),
    );
  }

  void loginUser() async {
    setState(() {
      _isloading = true;
    });
    String results = await authmethods().loginuser(
      email: _email.text,
      password: _pass.text,
    );
    if (results == 'succes') {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      showSnakBar(results, context);
    }
    setState(() {
      _isloading = false;
    });
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Image.asset('assets/carfood.png', height: 220),
                ),
                const SizedBox(height: 60),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'email',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                      borderSide:
                          BorderSide(width: 1, color: Colors.grey.shade600),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  controller: _pass,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    hintText: 'password',
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: loginUser,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      color: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                      ),
                    ),
                    child: _isloading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Log in',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('New here?  '),
                    ),
                    GestureDetector(
                      onTap: navigatetosingnup,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'create an account',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
