import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/components/my_button.dart';
import 'package:smart_garden_app/components/my_textfield.dart';
import 'package:smart_garden_app/components/square_tile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_garden_app/models/user.dart';
import 'package:smart_garden_app/screens/admin/AdminRoot.dart';
import 'package:smart_garden_app/screens/auth/auth_page.dart';
import 'package:smart_garden_app/screens/user/RegisterFace.dart';
import 'package:smart_garden_app/screens/user/UserHome.dart';
import 'package:smart_garden_app/screens/user/UserRoot.dart';
import 'package:smart_garden_app/util/authentication.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Initialize Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Authentication _authentication = Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.zero, // Đặt Padding thành EdgeInsets.zero
              margin: EdgeInsets.zero, // Đặt Margin thành EdgeInsets.zero
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/plants.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Giúp mở rộng Column để lấp đầy màn hình
                children: [
                  const SizedBox(height: 50),

                  // logo
                  Container(
                    width: 100, // Đặt kích thước của hình tròn tại đây
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Đặt hình dạng của container thành hình tròn
                      color: Colors.white, // Màu nền của container
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 45, // Bán kính của hình tròn
                        backgroundImage: AssetImage(
                            'assets/images/garden_logo.png'), // Hình ảnh logo
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // email textfield
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    text: "SignIn",
                    onTap: () {
                      _authentication
                          .signIn(
                              _emailController.text, _passwordController.text)
                          .then((value) {
                        // go to home screen
                        if (value?.getIdToken() != null) {
                          if (_emailController.text
                              .contains('admin@gmail.com')) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminRoot()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserRoot()));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Email or password invalid!')));
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ))
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Google sign-in button
                  FutureBuilder(
                    future: Authentication.initializeFirebase(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error initializing Firebase');
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        return GestureDetector(
                          onTap: () async {
                            User? user = await Authentication.signInWithGoogle(context: context);
                            if (user != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => UserHome(),
                                ),
                              );
                            }
                          }, // Call the sign-in method
                          child: SquareTile(imagePath: 'assets/images/google.png'),
                        );
                      }
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF57C00)),
                      );
                    },
                  ),

                  const SizedBox(height: 50),
                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                  // ... (your existing code)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
