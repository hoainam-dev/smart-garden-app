import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/components/my_button.dart';
import 'package:smart_garden_app/components/my_textfield.dart';
import 'package:smart_garden_app/components/square_tile.dart';
import 'package:smart_garden_app/screens/auth/LoginOrRegisterPage.dart';
import 'package:smart_garden_app/screens/user/UserHome.dart';
import 'package:smart_garden_app/service/userService.dart';
import 'package:smart_garden_app/util/authentication.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  // Initialize Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Authentication _authentication = Authentication();

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
                  const SizedBox(height: 25),

                  // logo
                  Container(
                    width: 100, // Đặt kích thước của hình tròn tại đây
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape
                          .circle, // Đặt hình dạng của container thành hình tròn
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

                  const SizedBox(height: 25),

                  // welcome back, you've been missed!
                  Text(
                    'Let\'s create a account for you!',
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
                    controller: _nameController,
                    hintText: 'Name',
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
                  //comfim password
                  MyTextField(
                    controller: _confirmpasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    text: "SignUp",
                    onTap: () async {
                      final String name = _nameController.text;
                      final String email = _emailController.text;
                      final String password = _passwordController.text;
                      final String confirmpassword = _confirmpasswordController.text;

                      bool validate = true;
                      String? message;
                      final UserService _userService = UserService();

                      const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

                      final regExp = RegExp(pattern);

                      if (name.isEmpty &&
                          email.isEmpty &&
                          password.isEmpty &&
                          confirmpassword.isEmpty) {
                        setState(() {
                          validate = false;
                          message =
                          "Please enter your information!";
                        });
                      } else if (name.isEmpty) {
                        setState(() {
                          validate = false;
                          message =
                          "You have to enter your name!";
                        });
                      } else if (email.isEmpty) {
                        setState(() {
                          validate = false;
                          message =
                          "You have to enter your email!";
                        });
                      } else if (password.isEmpty ||
                          confirmpassword.isEmpty) {
                        setState(() {
                          validate = false;
                          message =
                          "You have to enter your password!";
                        });
                      } else if (password != confirmpassword) {
                        validate = false;
                        setState(() {
                          validate = false;
                          message =
                          "Password not match! Please check again.";
                        });
                      } else if (!(password.length > 5) &&
                          password.isNotEmpty) {
                        setState(() {
                          validate = false;
                          message =
                          "Password should contain more than 5 characters";
                        });
                      } else if (!(regExp.hasMatch(email))) {
                        setState(() {
                          validate = false;
                          message =
                          "Email not valid! please enter again.";
                        });
                      }

                      if (validate) {
                        await _userService.getUserByEmail(email);
                        if (_userService.user == null) {
                          _authentication.createUser(
                              name, email, password);
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) {
                                    return LoginOrRegisterPage();
                                  }));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              content: Text(
                                  'Create account successfully. Let Login!')));
                        }else{
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              content: Text(
                                "email address exist.",
                                style: TextStyle(color: Colors.red),
                              )));
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            content: Text(
                              "${message}",
                              style: TextStyle(color: Colors.red),
                            )));
                      }
                    },
                  ),

                  const SizedBox(height: 25),
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

                  const SizedBox(height: 25),

                  // Google sign-in button
                  FutureBuilder(
                    future: Authentication.initializeFirebase(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error initializing Firebase');
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        return GestureDetector(
                          onTap: () async {
                            User? user = await Authentication.signInWithGoogle(
                                context: context);
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
                  const SizedBox(height: 30),
                  // not a member? register now
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Login now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
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
